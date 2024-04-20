//
//  VideoView.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 17/04/24.
//

import UIKit
import AVKit
import AVFoundation

protocol VideoViewDelegate: AnyObject {
    func playerReadyToPlay()
    func playerDidPlayToEnd()
    func playerPlayingStatusChange(_ isPlaying: Bool)
}

class VideoView: UIView {
    
    weak var delegate: VideoViewDelegate?
    
    deinit {
        removePlayerObserver()
        print("deinit of VideoView")
    }
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    var videoURL: URL?
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.needsDisplayOnBoundsChange = true
        playerLayer.masksToBounds = true
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var playerItemContext = 0
    
    private var playerItem: AVPlayerItem?
    
    func play(with url: URL) {
        setUpAsset(with: url) { [weak self] (asset: AVAsset) in
            self?.setUpPlayerItem(with: asset)
        }
    }
    
    private func setUpAsset(with url: URL, completion: ((_ asset: AVAsset) -> Void)?) {
        let asset = AVAsset(url: url)
        
        Task {
            do {
                let isPlayable = try await asset.load(.isPlayable)
                if isPlayable {
                    completion?(asset)
                } else {
                    print("Cannot play video")
                }
            } catch(let error) {
                print(error.localizedDescription)
            }
        }
    }
    
    private func setUpPlayerItem(with asset: AVAsset) {
        DispatchQueue.global().async { [weak self] in
            self?.removePlayerObserver()
            self?.playerItem = AVPlayerItem(asset: asset)
            self?.addPlayerObserver()
            
            DispatchQueue.main.async { [weak self] in
                if self?.player == nil {
                    self?.player = AVPlayer(playerItem: self?.playerItem!)
                } else {
                    self?.player?.replaceCurrentItem(with: self?.playerItem!)
                }
            }
        }
    }
    
    private func removePlayerObserver() {
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.removeObserver(self, name: pauseAllPlayback, object: nil)
    }
    
    private func addPlayerObserver() {
        playerItem?.addObserver(
            self,
            forKeyPath: #keyPath(AVPlayerItem.status),
            options: [.old, .new],
            context: &playerItemContext
        )
        // did play to end
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didPlayToEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: nil
        )
        // general pause on PauseAllPlayback
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(pauseAllPlaybackNotification),
            name: pauseAllPlayback,
            object: nil
        )
    }
    
    @objc func pauseAllPlaybackNotification() {
        player?.pause()
    }
    
    @objc func didPlayToEnd() {
        player?.seek(to: .zero)
        delegate?.playerDidPlayToEnd()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if keyPath == #keyPath(AVPlayerItem.status) {
            
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            switch status {
                case .readyToPlay:
//                    print(".readyToPlay")
                    delegate?.playerReadyToPlay()
                case .failed:
                    print(".failed")
                    break
                case .unknown:
                    print(".unknown")
                    break
                @unknown default:
                    print("@unknown default")
                    break
            }
        }
    }
}

let pauseAllPlayback = NSNotification.Name(rawValue: "PauseAllPlayback")

extension VideoView {
    static func triggerPauseMediaPlaybackNotification() {
        NotificationCenter.default.post(name: pauseAllPlayback, object: nil, userInfo: nil)
    }
}
