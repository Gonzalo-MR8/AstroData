//
//  AudioPlayer.swift
//  InfoSpace
//
//  Created by GonzaloMR on 1/12/23.
//

import MediaPlayer

protocol AudioPlayerProtocol: AnyObject {
  func played()
  func paused()
  func periodicTimeObserver(time: CMTime)
}

class AudioPlayer {

  static let shared = AudioPlayer()

  private var player: AVPlayer!
  private var timeObserverToken: Any?

  private var playerDuration: CMTime!
  private var durationInSeconds: Double!

  weak var delegate: AudioPlayerProtocol?

  private init() {
    let commandCenter = MPRemoteCommandCenter.shared()
    commandCenter.playCommand.addTarget { [weak self] _ in
      guard let self else { return .commandFailed }
      playPauseToggle()
      return .success
    }

    commandCenter.pauseCommand.addTarget { [weak self] _ in
      guard let self else { return .commandFailed }
      playPauseToggle()
      return .success
    }

    commandCenter.changePlaybackPositionCommand.addTarget { [weak self] event in
      guard let self, let event = event as? MPChangePlaybackPositionCommandEvent else { return .commandFailed }
      player.seek(to: CMTime(seconds: event.positionTime, preferredTimescale: 1))
      return .success
    }
  }

  func configureNewPlayer(player: AVPlayer, title: String, photographer: String?) {
    let nowPlayingTitle = MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyTitle] as? String
    /// Check if is the same player to update the view or the view and the player
    guard nowPlayingTitle != title else {
      return
    }
    /// remove time observer if there is a new player to have only one time observer, and doesn't duplicate audio
    if let timeObserverToken {
      self.player.removeTimeObserver(timeObserverToken)
    }
    /// Configure player
    self.player = player

    do {
      try AVAudioSession.sharedInstance().setCategory(.playback)
    } catch {
      CustomNavigationController.instance.presentDefaultAlert(title: "ERROR".localized, message: "TRY_IT_LATER".localized) { _ in
        CustomNavigationController.instance.dismissVC(animated: true)
      }
    }

    addPeriodicTimeObserver()

    guard let duration = player.currentItem?.asset.duration else {
      CustomNavigationController.instance.presentDefaultAlert(title: "ERROR".localized, message: "TRY_IT_LATER".localized) { _ in
        CustomNavigationController.instance.dismissVC(animated: true)
      }
      return
    }

    playerDuration = duration
    durationInSeconds = Double(duration.value) / Double(duration.timescale)
    /// Configure Audio notification
    var nowPlayingInfo: [String: Any] = [:]

    if let image = UIImage(named: "baseAppIcon") {
      nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { size in
        return image.imageWith(newSize: size)
      }
    }

    nowPlayingInfo[MPMediaItemPropertyTitle] = title
    if let photographer {
      nowPlayingInfo[MPMediaItemPropertyArtist] = photographer
    }

    nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = durationInSeconds
    MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
  }

  private func addPeriodicTimeObserver() {
    let timeScale = CMTimeScale(NSEC_PER_SEC)
    let time = CMTime(seconds: 1, preferredTimescale: timeScale)

    timeObserverToken = player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
      guard let self else { return }

      let timeInSeconds = CMTimeGetSeconds(time)

      if durationInSeconds == timeInSeconds {
        player.pause()
      }

      var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo
      nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = timeInSeconds
      MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo

      /// Notifies the view if the Audio ends
      if getPlayerDurationInSeconds() == timeInSeconds {
        delegate?.paused()
      }

      delegate?.periodicTimeObserver(time: time)
    }
  }

  public func playPauseToggle() {
    let timeInSeconds = Int(player.currentTime().value) / Int(player.currentTime().timescale)

    guard Int(durationInSeconds) != timeInSeconds else {
      let targetTime: CMTime = CMTimeMake(value: 0, timescale: 1)
      player.seek(to: targetTime) { [weak self] _ in
        guard let self else { return }
        player.play()
        delegate?.played()
      }
      return
    }

    /// Notifies the view if the Audio start or stop
    if player.rate != 0 {
      player.pause()
      delegate?.paused()
    } else {
      player.play()
      delegate?.played()
    }
  }

  public func getPlayer() -> AVPlayer {
    return player
  }

  public func getPlayerDuration() -> CMTime {
    return playerDuration
  }

  public func getPlayerDurationInSeconds() -> Double {
    return durationInSeconds
  }

  public func setPlayerTime(targetTime: CMTime) {
    player.seek(to: targetTime)
  }

  public func setPlayerTime(targetTime: CMTime, completionHandler: @escaping (Bool) -> Void) {
    player.seek(to: targetTime, completionHandler: completionHandler)
  }

  /// Check if the audio and the view is the same when the user reenter to the view to sincronice the view
  public func sameTime(title: String) -> CMTime? {
    let nowPlayingTitle = MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyTitle] as? String

    if nowPlayingTitle == title {
      return player.currentTime()
    }

    return nil
  }

  /// Check if the audio is playing or stopped when the user reenters to the view
  public func reloadPlayer() {
    if player.rate == 0 {
      delegate?.paused()
    } else if player.rate == 1 {
      delegate?.played()
    }
  }
}
