//
//  SIDetailAudioCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 11/12/22.
//

import UIKit
import AVFoundation

class SIDetailAudioCell: UITableViewCell {
    
    @IBOutlet weak var imageViewPlayPause: UIImageView!
    @IBOutlet weak var sliderProgress: Slider!
    @IBOutlet weak var labelCurrentTime: UILabel!
    @IBOutlet weak var labelDuration: UILabel!
    
    private var player: AVPlayer!
    private var timeObserverToken: Any?
    
    private var sliderIsBeingModified: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.sliderTapped(_:)))
        sliderProgress.addGestureRecognizer(gestureRecognizer)
    }
    
    func configure(url: URL) {
        let playerItem: AVPlayerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        addPeriodicTimeObserver()
        
        guard let duration = player.currentItem?.asset.duration else { return }
        
        let timeInSeconds = Double(duration.value) / Double(duration.timescale)
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional

        labelDuration.text = formatter.string(from: TimeInterval(timeInSeconds))
    }

    private func addPeriodicTimeObserver() {
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 1, preferredTimescale: timeScale)

        timeObserverToken = player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [self] time in
            setLabelCurrentTime(time: time)
        }
    }
    
    private func setLabelCurrentTime(time: CMTime) {
        let timeInSeconds = Double(time.value) / Double(time.timescale)
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional

        labelCurrentTime.text = formatter.string(from: TimeInterval(timeInSeconds))
        
        guard !sliderIsBeingModified else { return }
        guard let duration = player.currentItem?.asset.duration else { return }
        
        let durationInSeconds = Double(duration.value) / Double(duration.timescale)
        sliderProgress.setValue(Float(timeInSeconds / durationInSeconds), animated: true)
    }
    
    @objc func sliderTapped(_ sender: UIGestureRecognizer) {
        sliderIsBeingModified = true
        
        guard let slider = sender.view as? UISlider, !slider.isHighlighted else { return }
        guard let duration = player.currentItem?.asset.duration else { return }
                                   
        let point: CGPoint = sender.location(in: slider)
        let percentage = point.x / slider.bounds.size.width
        let delta = Float(percentage) * Float(slider.maximumValue - slider.minimumValue)
        let value = slider.minimumValue + delta
        slider.setValue(Float(value), animated: true)
        
        let targetTime: CMTime = CMTimeMake(value: Int64(Float(duration.value) * value), timescale: duration.timescale)
        player.seek(to: targetTime) { [self] _ in
            sliderIsBeingModified = false
        }
    }
    
    @IBAction func playPauseButtonPressed(_ sender: Any) {
        if player.rate != 0 {
            player.pause()
            imageViewPlayPause.image = UIImage(systemName: "play")
        } else {
            player.play()
            imageViewPlayPause.image = UIImage(systemName: "pause")
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        sliderIsBeingModified = true
        
        guard let duration = player.currentItem?.asset.duration else { return }
        
        let targetTime: CMTime = CMTimeMake(value: Int64(Float(duration.value) * sliderProgress.value), timescale: duration.timescale)
        player.seek(to: targetTime)
    }
    
    @IBAction func sliderDidEndDrag(_ sender: Any) {
        sliderIsBeingModified = false
    }
}
