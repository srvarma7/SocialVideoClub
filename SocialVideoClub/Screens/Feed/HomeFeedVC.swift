//
//  HomeFeedVC.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 16/04/24.
//

import UIKit
import EasyPeasy

class HomeFeedVC: TableViewFeedVC {
    
    weak var coordinator: MainCoordinator?
    
    let viewModel = HomeFeedViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Social Club"
        
//        refreshControl.beginRefreshing()
        viewModel.delegate = self
        viewModel.fetchPosts()
    }
    
    override func didPullToRefresh() {
        viewModel.fetchLatestFeed()
    }
    
    override func scrollOffsetDidChange(contentOffset: CGPoint) {
        super.scrollOffsetDidChange(contentOffset: contentOffset)
        let scrollPercentage = ((contentOffset.y + 80) / tableView.contentSize.height) * 100
        print(scrollPercentage)
        
        if scrollPercentage > 85 {
            viewModel.fetchPosts()
        }
    }
}

extension HomeFeedVC: HomeFeedDelegate {
    func didFetchFeed() {
        tableView.reloadData()
        refreshControl.endRefreshing()
        print("end refresh")
    }
    
    func didFetchFeedFailed() {
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
}


// MARK: - Table View


extension HomeFeedVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.objects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = viewModel.objects[indexPath.row]
        
        if let postModel = object as? PostModel {
            let postCell = tableView.dequeueReusableCell(withIdentifier: PostCell.id, for: indexPath) as! PostCell
            postCell.delegate = self
            postCell.bind(postModel, location: .feed)
            return postCell
        }
        
        if let token = object as? Tokens {
            if token == Tokens.isLoading {
                let loadingCell = tableView.dequeueReusableCell(withIdentifier: LoadingCell.id, for: indexPath) as! LoadingCell
                return loadingCell
            }
            
            if token == Tokens.hasNoMoreFeed {
                let messageCell = tableView.dequeueReusableCell(withIdentifier: MessageCell.id, for: indexPath) as! MessageCell
                messageCell.messageImageView.image  = token.image
                messageCell.messageLabel.text       = token.description
                return messageCell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if let cell = tableView.cellForRow(at: indexPath) {
            let visibility = cell.visiblePercentageInSuperView()
            if visibility < 90 {
                tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            } else {
                let object = viewModel.objects[indexPath.row]
                if let postModel = object as? PostModel {
                    coordinator?.showPost(post: postModel)
                }
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let object = viewModel.objects[indexPath.row]
        if let _ = object as? PostModel {
            return view.frame.width * 16/10
        }
        
        if let token = object as? Tokens {
            if token == Tokens.isLoading {
                return LoadingCell.height
            }
            
            if token == Tokens.hasNoMoreFeed {
                return MessageCell.height
            }
        }
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row == viewModel.objects.count - 1 {
//            viewModel.fetchPosts()
//        }
    }
}

extension HomeFeedVC: VideoCellDelegate {
    func showProfile(name: String) {
        coordinator?.showProfile(name: name)
    }
}

import SwiftUI

#Preview {
    let navVC = UINavigationController(rootViewController: HomeFeedVC())
    return navVC
}
