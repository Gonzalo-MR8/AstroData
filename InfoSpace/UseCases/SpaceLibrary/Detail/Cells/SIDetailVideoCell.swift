//
//  SIDetailVideoCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 23/11/22.
//

import UIKit
import AVKit
import CoreMotion

class SIDetailVideoCell: UITableViewCell {
    
    @IBOutlet private weak var viewPlayer: View!
    @IBOutlet private weak var viewHeight: NSLayoutConstraint!
    @IBOutlet private weak var buttonFullScreen: UIButton!
    
    public var player: AVPlayer!
    private let manager = CMMotionManager()
    private var avVController: AVPlayerViewController!
    private var parentVController: UIViewController!
    
    /// 16:9 Multiplier
    private let kAspectRatioMultiplier: CGFloat = 1.78
    private let kViewMultiplierWidth: CGFloat = 0.9
    
    func configure(url: URL, frameWidth: CGFloat, viewController: UIViewController) {
        parentVController = viewController
        player = AVPlayer(url: url)
        
        viewHeight.constant = (frameWidth * kViewMultiplierWidth) / kAspectRatioMultiplier
        self.layoutIfNeeded()
        
        loadAvPlayer()
    }
    
    private func loadAvPlayer() {
        avVController = AVPlayerViewController()
        avVController.player = player
        avVController.willMove(toParent: parentVController)
        avVController.view.frame = CGRect(x: 0, y: 0, width: viewPlayer.frame.width, height: viewPlayer.frame.height)
        viewPlayer.addSubview(avVController.view)
        parentVController.addChild(avVController)
        avVController.didMove(toParent: parentVController)
        try! AVAudioSession.sharedInstance().setCategory(.playback)
        startAccelerometerUpdates()
    }
    
    private func startAccelerometerUpdates() {
        manager.accelerometerUpdateInterval = 0.5
        manager.startAccelerometerUpdates(to: .main) { [self] (data, error) in
            guard let xAceleration = manager.accelerometerData?.acceleration.x else { return }
            
            if xAceleration > 0.82 || xAceleration < -0.82 {
                loadFullScreen()
            }
        }
    }
    
    private func loadFullScreen() {
        manager.stopAccelerometerUpdates()
        avVController.player = nil

        let avController = AVPlayerViewController()
        avController.transitioningDelegate = self
        avController.player = player
        CustomNavigationController.instance.present(to: avController, animated: true, completion: {
            self.player.play()
        })
    }
    
    @IBAction func buttonFullScreenPressed(_ sender: Any) {
        loadFullScreen()
    }
}

extension SIDetailVideoCell: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        guard let controller = dismissed as? AVPlayerViewController else {
            return nil
        }
        controller.player = nil
        avVController.player = player
        player.play()
        startAccelerometerUpdates()
        return nil
    }
}
