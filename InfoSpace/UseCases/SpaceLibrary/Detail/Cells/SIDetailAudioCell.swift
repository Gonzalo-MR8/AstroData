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
    
    public var player: AVPlayer!
    private var timeObserverToken: Any?
    private var sliderIsBeingModified: Bool = false
    
    private let kThumbSize: CGFloat = 14
    private let kMinPercentageToChnageColor: Float = 0.06
    private let kTimeToMove: Int64 = 10
    
    private var playerDuration: CMTime!
    private var durationInSeconds: Double!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let defaultStateBlueColorImage = UIImage.createThumbImage(size: kThumbSize, color: Colors.primaryColor.value)
        sliderProgress.setThumbImage(defaultStateBlueColorImage, for: .normal)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.sliderTapped(_:)))
        sliderProgress.addGestureRecognizer(gestureRecognizer)
    }
    
    func configure(url: URL) {
        player = AVPlayer(url: url) 
        
        try! AVAudioSession.sharedInstance().setCategory(.playback)
        
        addPeriodicTimeObserver()
        
        guard let duration = player.currentItem?.asset.duration else {
            CustomNavigationController.instance.presentDefaultAlert(title: "ERROR".localized, message: "TRY_IT_LATER".localized) { _ in
                CustomNavigationController.instance.dismissVC(animated: true)
            }
            return
        }
        
        playerDuration = duration
        durationInSeconds = Double(duration.value) / Double(duration.timescale)

        labelDuration.text = setTimeFormat(timeInSeconds: durationInSeconds)
    }

    private func addPeriodicTimeObserver() {
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 1, preferredTimescale: timeScale)

        timeObserverToken = player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [self] time in
            setLabelCurrentTime(time: time)
            
            let timeInSeconds = Int(time.value) / Int(time.timescale)
            
            if Int(durationInSeconds) == timeInSeconds {
                player.pause()
                imageViewPlayPause.image = UIImage(systemName: "play")
            }
        }
    }
    
    private func setTimeFormat(timeInSeconds: Double) -> String {
        if timeInSeconds < 60 {
            return "0:\(String(format: "%02d", Int(timeInSeconds)))"
        }
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        
        return formatter.string(from: TimeInterval(timeInSeconds))!
    }
    
    private func setLabelCurrentTime(time: CMTime) {
        let timeInSeconds = Double(time.value) / Double(time.timescale)

        labelCurrentTime.text = setTimeFormat(timeInSeconds: timeInSeconds)
        
        guard !sliderIsBeingModified else { return }
        
        sliderProgress.setValue(Float(timeInSeconds / durationInSeconds), animated: true)
        
        updateThumbColor()
    }
    
    private func updateThumbColor() {
        if sliderProgress.value > kMinPercentageToChnageColor {
            let point = CGPoint(x: sliderProgress.frame.width * CGFloat(sliderProgress.value), y: sliderProgress.frame.minY)
            let color = self.colorOfPoint(point: point)
            sliderProgress.setThumbImage(sliderProgress.currentThumbImage?.withTintColor(color), for: .normal)
        } else {
            sliderProgress.setThumbImage(sliderProgress.currentThumbImage?.withTintColor(Colors.primaryColor.value), for: .normal)
        }
    }
    
    private func moveClipTime(sum: Bool) {
        sliderIsBeingModified = true
        updateThumbColor()
        
        let timeInSeconds = Double(player.currentTime().value) / Double(player.currentTime().timescale)
        let targetTime: CMTime!
        
        if sum {
            targetTime = CMTimeMake(value: Int64(timeInSeconds) + kTimeToMove, timescale: 1)
        } else {
            targetTime = CMTimeMake(value: Int64(timeInSeconds) - kTimeToMove, timescale: 1)
        }
        
        player.seek(to: targetTime) { [self] _ in
            sliderIsBeingModified = false
        }
    }
    
    @objc func sliderTapped(_ sender: UIGestureRecognizer) {
        sliderIsBeingModified = true
        
        guard let slider = sender.view as? UISlider, !slider.isHighlighted else { return }
                                   
        let point: CGPoint = sender.location(in: slider)
        let percentage = point.x / slider.bounds.size.width
        let delta = Float(percentage) * Float(slider.maximumValue - slider.minimumValue)
        let value = slider.minimumValue + delta
        slider.setValue(Float(value), animated: true)
        
        updateThumbColor()
        
        let targetTime: CMTime = CMTimeMake(value: Int64(Float(playerDuration.value) * value), timescale: playerDuration.timescale)
        player.seek(to: targetTime) { [self] _ in
            sliderIsBeingModified = false
        }
    }
    
    @IBAction func playPauseButtonPressed(_ sender: Any) {
        let timeInSeconds = Int(player.currentTime().value) / Int(player.currentTime().timescale)
        
        guard Int(durationInSeconds) != timeInSeconds else {
            let targetTime: CMTime = CMTimeMake(value: 0, timescale: 1)
            player.seek(to: targetTime) { [self] _ in
                imageViewPlayPause.image = UIImage(systemName: "pause")
                player.play()
            }
            return
        }
        
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
        updateThumbColor()
        
        let targetTime: CMTime = CMTimeMake(value: Int64(Float(playerDuration.value) * sliderProgress.value), timescale: playerDuration.timescale)
        player.seek(to: targetTime)
    }
    
    @IBAction func goBackPressed(_ sender: Any) {
        moveClipTime(sum: false)
    }
    
    @IBAction func advancePressed(_ sender: Any) {
        moveClipTime(sum: true)
    }
    
    @IBAction func sliderDidEndDrag(_ sender: Any) {
        sliderIsBeingModified = false
    }
}
