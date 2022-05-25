//
//  HudView.swift
//  InfoSpace
//
//  Created by Gonzalo MR on 24/5/22.
//

import UIKit
import Lottie

class HudView: UIView {

    @IBOutlet weak var viewBlur: UIVisualEffectView!
    @IBOutlet weak var animationView: AnimationView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    /*deinit {
        NotificationCenter.default.removeObserver(self, name: .AppWillEnterForeground, object: nil)
        NotificationCenter.default.removeObserver(self, name: .AppDidEnterBackground, object: nil)
    }*/
    
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
        /*NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: .AppWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: .AppDidEnterBackground, object: nil)*/
    }
    
}
