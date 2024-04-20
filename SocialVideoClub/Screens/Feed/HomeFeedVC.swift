//
//  HomeFeedVC.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 16/04/24.
//

import UIKit
import EasyPeasy

class HomeFeedVC: ClubBaseTableViewVC {
    
    weak var coordinator: MainCoordinator?
    
    lazy var viewModel = HomeFeedViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Social Club"
        
//        refreshControl.beginRefreshing()
        viewModel.delegate = self
        viewModel.dataSource = dataSource
        viewModel.fetchPosts()
    }
    
    override func didPullToRefresh() {
        viewModel.fetchLatestFeed()
    }
    
    override func scrollOffsetDidChange(contentOffset: CGPoint) {
        super.scrollOffsetDidChange(contentOffset: contentOffset)
        let scrollPercentage = ((contentOffset.y + 80) / tableView.contentSize.height) * 100
        
        if scrollPercentage > 85 {
            viewModel.fetchPosts()
        }
    }
    
    @objc override func cellDisplayLocation() -> ScreenLocation {
        return .feed
    }
}

extension HomeFeedVC: HomeFeedDelegate {
    func didFetchFeed() {
        refreshControl.endRefreshing()
    }
    
    func didFetchFeedFailed() {
        refreshControl.endRefreshing()
    }
}


// MARK: - Table View


extension HomeFeedVC {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if let cell = tableView.cellForRow(at: indexPath) {
            let visibility = cell.visiblePercentageInSuperView()
            if visibility < 90 {
                tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            } else {
                if let item = dataSource.itemIdentifier(for: indexPath) {
                    switch item {
                        case .post(let post):
                            coordinator?.showPost(post: post)
                            return
                            
                        default:
                            return
                    }
                }
            }
        }
        
    }
}

extension HomeFeedVC {
    override func showProfile(name: String) {
        coordinator?.showProfile(name: name)
    }
}

//import SwiftUI
//
//#Preview {
//    let navVC = UINavigationController(rootViewController: HomeFeedVC())
//    return navVC
//}
