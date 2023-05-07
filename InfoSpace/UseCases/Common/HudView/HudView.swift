//
//  HudView.swift
//  InfoSpace
//
//  Created by Gonzalo MR on 24/5/22.
//

import UIKit
import Lottie

protocol HudViewProtocol { }

class HudView: UIView {

    @IBOutlet private weak var viewBlur: UIVisualEffectView!
    @IBOutlet private weak var animationView: AnimationView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .AppWillEnterForeground, object: nil)
        NotificationCenter.default.removeObserver(self, name: .AppDidEnterBackground, object: nil)
    }
    
    func startAnimating() {
        animationView.play()
    }
    
    func stopAnimating() {
        animationView.stop()
    }
    
    // MARK: - Notifications
    
    @objc func appWillEnterForeground(notification: Notification) {
        startAnimating()
    }
    
    @objc func appDidEnterBackground(notification: Notification) {
        stopAnimating()
    }
    
    // MARK: - Private methods
    
    private func setup() {
        setupNib()
        
        animationView.loopMode = .loop
        
        // Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: .AppWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: .AppDidEnterBackground, object: nil)
    }
    
}

extension HudViewProtocol where Self: UIViewController {
    func showHudView() {
        let hudView = HudView()
        view.addSubview(hudView)
        
        hudView.translatesAutoresizingMaskIntoConstraints = false
        hudView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        hudView.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
        hudView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hudView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        hudView.startAnimating()
        
        hudView.tag = Constants.kHudViewTag
    }
    
    func hideHudView() {
        view.subviews.first(where: { $0.tag == Constants.kHudViewTag })?.removeFromSuperview()
    }
}
