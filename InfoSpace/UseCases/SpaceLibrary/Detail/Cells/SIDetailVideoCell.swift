//
//  SIDetailVideoCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 23/11/22.
//

import UIKit
import AVKit

class SIDetailVideoCell: UITableViewCell {
    
    @IBOutlet weak var viewPlayer: View!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonFullScreen: UIButton!
    
    var player: AVPlayer!
    
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
    }
    
    @IBAction func buttonFullScreenPressed(_ sender: Any) {
        avVController.player = nil

        let avController = AVPlayerViewController()
        avController.transitioningDelegate = self
        avController.player = player
        CustomNavigationController.instance.present(to: avController, animated: true, completion: {
            self.player.play()
        })
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
        return nil
    }
}
