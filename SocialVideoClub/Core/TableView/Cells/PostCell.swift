//
//  PostCell.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 17/04/24.
//

import UIKit
import EasyPeasy
import SDWebImage

// Used to configure UI based on the location
@objc enum ScreenLocation: Int {
    case feed
    case post               // Enables like button and profile image in the Post
    case profile
}

protocol VideoCellDelegate: AnyObject {
    func showProfile(name: String)                  // Call for navigating to Profile by name
    func cellDisplayLocation() -> ScreenLocation
}

final class PostCell: UITableViewCell {
    
    var playerInitializeTimer: Timer?
    static let id = PostCell.description()
    
    var post: PostModel?
    weak var delegate: VideoCellDelegate?
    
    var screenLocation: ScreenLocation = .feed
    
    lazy private var username: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    lazy private var userImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy private var userDetailsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [userImage, username])
        stack.distribution = .fillProportionally
        stack.spacing = 5
        stack.axis = .horizontal
        let tap = UITapGestureRecognizer(target: self, action: #selector(showProfile))
        stack.addGestureRecognizer(tap)
        stack.isUserInteractionEnabled = true
        return stack
    }()
    
    lazy private var thumbnailImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy private var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    lazy private var nLikesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    lazy private var likesStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [likeButton, nLikesLabel])
        stack.distribution = .fillProportionally
        stack.spacing = 5
        stack.axis = .horizontal
        return stack
    }()

    
    private var isLiked: Bool = false
    
    private let videoContainer = UIView()
    private let videoPlayer = VideoView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        updateLikeButtonUI()
        videoPlayer.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // Resetting cell to avoid using unrelated content
    override func prepareForReuse() {
        super.prepareForReuse()
        playerInitializeTimer?.invalidate()
        playerInitializeTimer = nil
        userImage.isHidden = true
        thumbnailImage.isHidden = false
        videoPlayer.removePlayerObserver()
        videoPlayer.player?.replaceCurrentItem(with: nil)
    }
}


// MARK: - Action Responders


extension PostCell {
    @objc private func didTapLikeButton() {
        isLiked.toggle()
        if let nLikes = post?.likes {
            post?.likes = isLiked ? nLikes + 1 : nLikes - 1
        }
        updateLikeButtonUI()
        updateLikesLabel()
    }
    
    @objc func showProfile() {
        if let name = post?.username {
            delegate?.showProfile(name: name)
        }
    }
}


// MARK: - UI Updates


extension PostCell {
    private func updateLikeButtonUI() {
        let image = UIImage(systemName: isLiked ? "heart.fill" : "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32))
        UIView.animate(withDuration: 0.2) { [self] in
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = isLiked ? .red : .white
        }
    }
    
    private func updateLikesLabel() {
        nLikesLabel.text = "\(post?.likes ?? 0) likes"
    }
}

extension PostCell {
    func isPlaying() -> Bool {
        return videoPlayer.player?.isPlaying ?? false
    }
    
    func startAutoPlay() {
        guard isPlaying() == false else {
            return
        }
        
        VideoView.triggerPauseMediaPlaybackNotification()
        videoPlayer.player?.play()
    }
    
    func cellDidEndDisplay() {
        videoPlayer.player?.pause()
    }
    
    func cellDidBeginDisplay() {
        
    }
}

extension PostCell: VideoViewDelegate {
    func playerReadyToPlay() {
        thumbnailImage.isHidden = true
        triggerAutoPlay()
    }
    
    func playerDidPlayToEnd() {
        triggerAutoPlay()
    }
    
    private func triggerAutoPlay() {
        if let superCV = superview as? UITableView {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                VideoAutoPlayManager.handle(cv: superCV)
            }
        }
    }
    
    func playerPlayingStatusChange(_ isPlaying: Bool) {
        print("isPlaying", isPlaying)
    }
}

extension PostCell {
    private func setupViews() {
        contentView.addSubview(videoContainer)
        videoContainer.easy.layout(
            Leading(),
            Trailing(),
            Top(),
            Bottom()
        )
        
        videoContainer.addSubview(videoPlayer)
        videoPlayer.easy.layout(
            Edges()
        )
        
        videoContainer.addSubview(thumbnailImage)
        thumbnailImage.easy.layout(
            Edges()
        )
        
        let topGradientView = GradientView()
        videoContainer.addSubview(topGradientView)
        topGradientView.easy.layout(
            Top(),
            Leading(),
            Trailing(),
            Height(45)
        )
        
        videoContainer.addSubview(userDetailsStackView)
        userDetailsStackView.easy.layout(
            Leading(15),
            Top(15),
            Height(30),
            Trailing(15)
        )
        
        userImage.easy.layout(
            Size(30)
        )
        
        let bottomGradientView = GradientView()
        bottomGradientView.colors = bottomGradientView.colors.reversed()
        
        videoContainer.addSubview(bottomGradientView)
        bottomGradientView.easy.layout(Bottom(), Leading(), Trailing(), Height(45))
        
        videoContainer.addSubview(likesStackView)
        likesStackView.easy.layout(
            Leading(15),
            Bottom(15),
            Height(30),
            Trailing(15)
        )
        
        likeButton.easy.layout(
            Size(30)
        )
    }
}

extension PostCell {
    func bind(_ post: PostModel) {
        self.post = post
        
        userImage.isHidden = true
        likeButton.isHidden = true
        
        if delegate?.cellDisplayLocation() == .post {
            likeButton.isHidden = false
            if let profileImage = post.profile_image, let userImageURL = URL(string: profileImage) {
                userImage.setImage(with: userImageURL)
                userImage.isHidden = false
            } else {
                userImage.isHidden = true
            }
        }
        
        username.text = post.username
        
        thumbnailImage.isHidden = false
        if let thumbImageURL = URL(string: post.thumbnail_url) {
            thumbnailImage.setImage(with: thumbImageURL)
        }
                
        updateLikesLabel()
        
        playerInitializeTimer = Timer.scheduledTimer(timeInterval: TimeInterval(0.15),
                                                     target: self,
                                                     selector: #selector(makePlayer),
                                                     userInfo: nil,
                                                     repeats: false)
    }
    
    @objc private func makePlayer() {
        if let post, let videoURL = URL(string: post.videoUrl) {
            videoPlayer.play(with: videoURL)
        }
    }
}
