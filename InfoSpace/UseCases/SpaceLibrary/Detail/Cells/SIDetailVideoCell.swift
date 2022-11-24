//
//  SIDetailVideoCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 23/11/22.
//

import UIKit
import AVFoundation

class SIDetailVideoCell: UITableViewCell {
    
    @IBOutlet weak var viewPlayer: View!
    
    private var playerItem: AVPlayerItem!
    private var player: AVPlayer!
    let nsCenter = NotificationCenter.default

    // Observer should always be set
    var playerObserver: NSKeyValueObservation!
    
    private var url: URL!
    
    func configure(url: URL) {
        self.url = url
        
        videoAnimationSetup()
    }
    
    // MARK: - Private Methods
    // Configure the video animation
    private func videoAnimationSetup() {
        let asset = AVAsset(url: url)
        
        // configure player
        playerItem = AVPlayerItem(asset: asset)
        observePlayer(playerItem)
        player = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: player)
        
        // add player layer to view layer
        playerLayer.frame = self.viewPlayer.frame
        playerLayer.videoGravity = .resizeAspectFill
        self.viewPlayer.layer.addSublayer(playerLayer)
        
        // handle video end
        nsCenter.addObserver(self, selector: #selector(videoEnded), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    
    // Observes when the player item is ready to play and handles automatic play back
    private func observePlayer(_ playerItem: AVPlayerItem) {
        playerObserver = playerItem.observe(\AVPlayerItem.status) { [weak self] (playerItem, _) in
            if playerItem.status == .readyToPlay {
                self?.player.play()
            }
        }
    }
    
    @objc private func videoEnded() {
        playerItem.seek(to: CMTime.zero) { (finished) in
            if finished {
                OperationQueue.main.addOperation { [weak self] in
                    self?.player.play()
                }
            }
        }
    }
}
