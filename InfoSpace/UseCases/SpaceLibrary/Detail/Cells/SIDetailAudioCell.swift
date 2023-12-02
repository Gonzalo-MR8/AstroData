//
//  SIDetailAudioCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 11/12/22.
//

import UIKit
import MediaPlayer

class SIDetailAudioCell: UITableViewCell {
    
    @IBOutlet private weak var imageViewPlayPause: UIImageView!
    @IBOutlet private weak var sliderProgress: CISlider!
    @IBOutlet private weak var labelCurrentTime: UILabel!
    @IBOutlet private weak var labelDuration: UILabel!

    private var sliderIsBeingModified: Bool = false
    
    private let kThumbSize: CGFloat = 14
    private let kMinPercentageToChnageColor: Float = 0.06
    private let kTimeToMove: Int64 = 10
    
    private var auPlayer = AudioPlayer.shared
    private var playerCandidate: AVPlayer!
    private var titleCandidate: String!
    private var photographerCandidate: String?
    private var isConfigured = false

    override func awakeFromNib() {
        super.awakeFromNib()

        let defaultStateBlueColorImage = UIImage.createThumbImage(size: kThumbSize, color: Colors.primaryColor.value)
        sliderProgress.setThumbImage(defaultStateBlueColorImage, for: .normal)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.sliderTapped(_:)))
        sliderProgress.addGestureRecognizer(gestureRecognizer)
    }
    
    func configure(player: AVPlayer, title: String, photographer: String?) {
      playerCandidate = player
      titleCandidate = title
      photographerCandidate = photographer

      guard let duration = player.currentItem?.asset.duration else {
        CustomNavigationController.instance.presentDefaultAlert(title: "ERROR".localized, message: "TRY_IT_LATER".localized) { _ in
          CustomNavigationController.instance.dismissVC(animated: true)
        }
        return
      }

      let durationInSeconds = Double(duration.value) / Double(duration.timescale)

      labelDuration.text = setTimeFormat(timeInSeconds: durationInSeconds)

      if let time = auPlayer.sameTime(title: title) {
        auPlayer.delegate = self
        setLabelCurrentTime(time: time)
        auPlayer.reloadPlayer()
      }
    }
    
    private func setTimeFormat(timeInSeconds: Double) -> String {
        if timeInSeconds < 60 {
            return "0:\(String(format: "%02d", Int(timeInSeconds)))"
        }
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        
        return formatter.string(from: TimeInterval(timeInSeconds)) ?? ""
    }
    
    private func setLabelCurrentTime(time: CMTime) {
        let timeInSeconds = Double(time.value) / Double(time.timescale)

        labelCurrentTime.text = setTimeFormat(timeInSeconds: timeInSeconds)
        
        guard !sliderIsBeingModified else { return }
        
        sliderProgress.setValue(Float(timeInSeconds / auPlayer.getPlayerDurationInSeconds()), animated: true)

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
        
        let timeInSeconds = Double(auPlayer.getPlayer().currentTime().value) / Double(auPlayer.getPlayer().currentTime().timescale)
        let targetTime: CMTime
        
        if sum {
            targetTime = CMTimeMake(value: Int64(timeInSeconds) + kTimeToMove, timescale: 1)
        } else {
            targetTime = CMTimeMake(value: Int64(timeInSeconds) - kTimeToMove, timescale: 1)
        }
        
        auPlayer.setPlayerTime(targetTime: targetTime) { [weak self] _ in
            guard let self else { return }
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

      let targetTime: CMTime = CMTimeMake(value: Int64(Float(auPlayer.getPlayerDuration().value) * value), timescale: auPlayer.getPlayerDuration().timescale)
      auPlayer.setPlayerTime(targetTime: targetTime) { [weak self] _ in
        guard let self else { return }
        sliderIsBeingModified = false
      }
    }
    
    @IBAction func playPauseButtonPressed(_ sender: Any) {
      /// Check if is the first press and if it is then configure de Audio Player
      if !isConfigured {
        AudioPlayer.shared.delegate = self
        auPlayer.configureNewPlayer(player: playerCandidate, title: titleCandidate, photographer: photographerCandidate)
        isConfigured = true
      }
      auPlayer.playPauseToggle()
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
      sliderIsBeingModified = true
      updateThumbColor()

      let targetTime: CMTime = CMTimeMake(value: Int64(Float(auPlayer.getPlayerDuration().value) * sliderProgress.value), timescale: auPlayer.getPlayerDuration().timescale)
      auPlayer.setPlayerTime(targetTime: targetTime)
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

extension SIDetailAudioCell: AudioPlayerProtocol {
  func played() {
    imageViewPlayPause.image = UIImage(systemName: "pause")
  }
  
  func paused() {
    imageViewPlayPause.image = UIImage(systemName: "play")
  }
  
  func changePlaybackPosition(event: MPChangePlaybackPositionCommandEvent) {
    sliderIsBeingModified = true
    updateThumbColor()

    auPlayer.setPlayerTime(targetTime: CMTime(seconds: event.positionTime, preferredTimescale: 1)) { [weak self] _ in
      guard let self else { return }
      self.sliderProgress.value = Float(event.positionTime / auPlayer.getPlayerDurationInSeconds())
    }
  }
  
  func periodicTimeObserver(time: CMTime) {
    updateThumbColor()
    setLabelCurrentTime(time: time)
  }
}
