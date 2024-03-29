//
//  SIDetailVideoCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 23/11/22.
//

import UIKit
import AVKit

class SIDetailVideoCell: UITableViewCell {
    
    @IBOutlet private weak var viewPlayer: CIView!
    @IBOutlet private weak var viewHeight: NSLayoutConstraint!
    @IBOutlet private weak var buttonFullScreen: UIButton!
    
    public var player: AVPlayer!
    
    private var avVController: AVPlayerViewController!
    private var parentVController: UIViewController!
    
    /// 16:9 Multiplier
    private let kAspectRatioMultiplier: CGFloat = 1.78
    private let kViewMultiplierWidth: CGFloat = 0.9
    
    func configure(player: AVPlayer, frameWidth: CGFloat, viewController: UIViewController) {
        parentVController = viewController
        self.player = player
        
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
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            CustomNavigationController.instance.presentDefaultAlert(title: "ERROR".localized, message: "TRY_IT_LATER".localized) { _ in
                CustomNavigationController.instance.dismissVC(animated: true)
            }
        }
    }
    
    private func loadFullScreen() {
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
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let controller = dismissed as? AVPlayerViewController else { return nil }
        
        controller.player = nil
        avVController.player = player
        player.play()
        return nil
    }
}
