//
//  Reachability.swift
//  InfoSpace
//
//  Created by GonzaloMR on 26/5/22.
//

import Foundation
import SystemConfiguration

public enum ReachabilityError: Error {
    case unableToSetCallback
    case unableToSetDispatchQueue
    case unableToGetInitialFlags
}

@available(*, unavailable, renamed: "Notification.Name.reachabilityChanged")
public let reachabilityChangedNotification = NSNotification.Name("ReachabilityChangedNotification")

public extension Notification.Name {
    static let reachabilityChanged = Notification.Name("reachabilityChanged")
}

public class Reachability {

    public typealias NetworkReachable = (Reachability) -> Void
    public typealias NetworkUnreachable = (Reachability) -> Void

    public enum Connection: CustomStringConvertible {
        case none, wifi, cellular
        public var description: String {
            switch self {
            case .cellular: return "Cellular"
            case .wifi: return "WiFi"
            case .none: return "No Connection"
            }
        }
    }

    public var whenReachable: NetworkReachable?
    public var whenUnreachable: NetworkUnreachable?

    /// Set to `false` to force Reachability.connection to .none when on cellular connection (default value `true`)
    public var allowsCellularConnection: Bool

    // The notification center on which "reachability changed" events are being posted
    public var notificationCenter: NotificationCenter = NotificationCenter.default

    public var connection: Connection {
        if flags == nil {
            try? setReachabilityFlags()
        }
        
        switch flags?.connection {
        case .none?, nil: return .none
        case .cellular?: return allowsCellularConnection ? .cellular : .none
        case .wifi?: return .wifi
        }
    }

    fileprivate var isRunningOnDevice: Bool = {
        #if targetEnvironment(simulator)
            return false
        #else
            return true
        #endif
    }()

    fileprivate var notifierRunning = false
    fileprivate let reachabilityRef: SCNetworkReachability
    fileprivate let reachabilitySerialQueue: DispatchQueue
    fileprivate(set) var flags: SCNetworkReachabilityFlags? {
        didSet {
            guard flags != oldValue else { return }
            reachabilityChanged()
        }
    }

    required public init(reachabilityRef: SCNetworkReachability, queueQoS: DispatchQoS = .default, targetQueue: DispatchQueue? = nil) {
        self.allowsCellularConnection = true
        self.reachabilityRef = reachabilityRef
        self.reachabilitySerialQueue = DispatchQueue(label: "uk.co.ashleymills.reachability", qos: queueQoS, target: targetQueue)
    }

    public convenience init?(hostname: String, queueQoS: DispatchQoS = .default, targetQueue: DispatchQueue? = nil) {
        guard let ref = SCNetworkReachabilityCreateWithName(nil, hostname) else { return nil }
        self.init(reachabilityRef: ref, queueQoS: queueQoS, targetQueue: targetQueue)
    }

    public convenience init?(queueQoS: DispatchQoS = .default, targetQueue: DispatchQueue? = nil) {
        var zeroAddress = sockaddr()
        zeroAddress.sa_len = UInt8(MemoryLayout<sockaddr>.size)
        zeroAddress.sa_family = sa_family_t(AF_INET)

        guard let ref = SCNetworkReachabilityCreateWithAddress(nil, &zeroAddress) else { return nil }

        self.init(reachabilityRef: ref, queueQoS: queueQoS, targetQueue: targetQueue)
    }

    deinit {
        stopNotifier()
    }
}

public extension Reachability {

    // MARK: - *** Notifier methods ***
    func startNotifier() throws {
        guard !notifierRunning else { return }

        let callback: SCNetworkReachabilityCallBack = { (reachability, flags, info) in
            guard let info = info else { return }

            let reachability = Unmanaged<Reachability>.fromOpaque(info).takeUnretainedValue()
            reachability.flags = flags
        }

        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = UnsafeMutableRawPointer(Unmanaged<Reachability>.passUnretained(self).toOpaque())
        if !SCNetworkReachabilitySetCallback(reachabilityRef, callback, &context) {
            stopNotifier()
            throw ReachabilityError.unableToSetCallback
        }

        if !SCNetworkReachabilitySetDispatchQueue(reachabilityRef, reachabilitySerialQueue) {
            stopNotifier()
            throw ReachabilityError.unableToSetDispatchQueue
        }

        // Perform an initial check
        try setReachabilityFlags()

        notifierRunning = true
    }

    func stopNotifier() {
        defer { notifierRunning = false }

        SCNetworkReachabilitySetCallback(reachabilityRef, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(reachabilityRef, nil)
    }
}

fileprivate extension Reachability {
    func setReachabilityFlags() throws {
        try reachabilitySerialQueue.sync { [unowned self] in
            var flags = SCNetworkReachabilityFlags()
            if !SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags) {
                self.stopNotifier()
                throw ReachabilityError.unableToGetInitialFlags
            }
            
            self.flags = flags
        }
    }
    
    func reachabilityChanged() {
        let block = connection != .none ? whenReachable : whenUnreachable

        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            block?(strongSelf)
            strongSelf.notificationCenter.post(name: .reachabilityChanged, object: strongSelf)
        }
    }
}

extension SCNetworkReachabilityFlags {

    typealias Connection = Reachability.Connection

    var connection: Connection {
        guard isReachableFlagSet else { return .none }

        // If we're reachable, but not on an iOS device (i.e. simulator), we must be on WiFi
        #if targetEnvironment(simulator)
        return .wifi
        #else
        var connection = Connection.none

        if !isConnectionRequiredFlagSet {
            connection = .wifi
        }

        if isConnectionOnTrafficOrDemandFlagSet {
            if !isInterventionRequiredFlagSet {
                connection = .wifi
            }
        }

        if isOnWWANFlagSet {
            connection = .cellular
        }

        return connection
        #endif
    }

    var isOnWWANFlagSet: Bool {
        #if os(iOS)
        return contains(.isWWAN)
        #else
        return false
        #endif
    }
    
    var isReachableFlagSet: Bool {
        return contains(.reachable)
    }
    
    var isConnectionRequiredFlagSet: Bool {
        return contains(.connectionRequired)
    }
    
    var isInterventionRequiredFlagSet: Bool {
        return contains(.interventionRequired)
    }
    
    var isConnectionOnTrafficFlagSet: Bool {
        return contains(.connectionOnTraffic)
    }
    
    var isConnectionOnDemandFlagSet: Bool {
        return contains(.connectionOnDemand)
    }
    
    var isConnectionOnTrafficOrDemandFlagSet: Bool {
        return !intersection([.connectionOnTraffic, .connectionOnDemand]).isEmpty
    }
    
    var isTransientConnectionFlagSet: Bool {
        return contains(.transientConnection)
    }
    
    var isLocalAddressFlagSet: Bool {
        return contains(.isLocalAddress)
    }
    
    var isDirectFlagSet: Bool {
        return contains(.isDirect)
    }
    
    var isConnectionRequiredAndTransientFlagSet: Bool {
        return intersection([.connectionRequired, .transientConnection]) == [.connectionRequired, .transientConnection]
    }
}
