//
//  VideoView.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 17/04/24.
//

import UIKit
import EasyPeasy
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
    
    lazy var bufferIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.needsDisplayOnBoundsChange = true
        playerLayer.masksToBounds = true
        clipsToBounds = true
        
        addSubview(bufferIndicator)
        bufferIndicator.easy.layout(Center(), Size(20))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var playerItemContext = 0
    
    private var playerItem: AVPlayerItem?
    
    private var playerItemStatusObserver: NSKeyValueObservation?
    private var playerItemBufferEmptyObserver: NSKeyValueObservation?
    private var playerItemBufferKeepUpObserver: NSKeyValueObservation?
    private var playerItemBufferFullObserver: NSKeyValueObservation?
    
    func play(with url: URL) {
        setUpAsset(with: url) { [weak self] asset in
            self?.setUpPlayerItem(with: asset)
        }
    }
    
    /// Load asset async
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
            
            DispatchQueue.main.async {
                if self?.player == nil {
                    self?.player = AVPlayer(playerItem: self?.playerItem!)
                } else {
                    self?.player?.replaceCurrentItem(with: self?.playerItem!)
                }
            }
        }
    }
    
    func removePlayerObserver() {
        playerItemStatusObserver?.invalidate()
        playerItemStatusObserver = nil
        
        playerItemBufferEmptyObserver?.invalidate()
        playerItemBufferEmptyObserver = nil
        
        playerItemBufferKeepUpObserver?.invalidate()
        playerItemBufferKeepUpObserver = nil
        
        playerItemBufferFullObserver?.invalidate()
        playerItemBufferFullObserver = nil
        
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.removeObserver(self, name: pauseAllPlayback, object: nil)
    }
    
    private func addPlayerObserver() {
        // Notify auto play that the asset is ready
        playerItemStatusObserver = playerItem?.observe(\AVPlayerItem.status, options: .new) { [weak self] _, change in
            guard let self, playerItem?.status == .readyToPlay else { return }
            delegate?.playerReadyToPlay()
        }
        
        // Activity indicator
        playerItemBufferEmptyObserver = playerItem?.observe(\AVPlayerItem.isPlaybackBufferEmpty, options: [.new]) { [weak self] (_, change) in
            guard let self else { return }
            bufferIndicator.startAnimating()
        }
        
        playerItemBufferKeepUpObserver = playerItem?.observe(\AVPlayerItem.isPlaybackLikelyToKeepUp, options: [.new]) { [weak self] (_, change) in
            guard let self = self else { return }
            bufferIndicator.stopAnimating()
        }
        
        playerItemBufferFullObserver = playerItem?.observe(\AVPlayerItem.isPlaybackBufferFull, options: [.new]) { [weak self] (_, change) in
            guard let self = self else { return }
            bufferIndicator.stopAnimating()
        }
        
        // did play to end
        NotificationCenter.default.addObserver(self, selector: #selector(didPlayToEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        // general pause on PauseAllPlayback
        NotificationCenter.default.addObserver(self, selector: #selector(pauseAllPlaybackNotification), name: pauseAllPlayback, object: nil)
    }
    
    @objc func pauseAllPlaybackNotification() {
        player?.pause()
    }
    
    @objc func didPlayToEnd() {
        player?.seek(to: .zero)
        delegate?.playerDidPlayToEnd()
    }
}

let pauseAllPlayback = NSNotification.Name(rawValue: "PauseAllPlayback")

extension VideoView {
    static func triggerPauseMediaPlaybackNotification() {
        NotificationCenter.default.post(name: pauseAllPlayback, object: nil, userInfo: nil)
    }
}
