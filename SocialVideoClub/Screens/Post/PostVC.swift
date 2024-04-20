//
//  PostVC.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 17/04/24.
//

import UIKit

class PostVC: ClubBaseTableViewVC {
    
    weak var coordinator: MainCoordinator?
    
    let viewModel: PostViewModel
    
    override var shouldAddScrollObserver: Bool {
        return true
    }
    
    init(viewModel: PostViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        viewModel.dataSource = dataSource
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Post"
        
        viewModel.fetchPost()
        viewModel.updateObject()
    }
    
    override func scrollOffsetDidChange(contentOffset: CGPoint) {
        VideoAutoPlayManager.handle(cv: tableView)
    }
    
    override func didPullToRefresh() {
        viewModel.refreshPost()
    }
    
    @objc override func cellDisplayLocation() -> ScreenLocation {
        return .post
    }
}

extension PostVC: PostViewModelDelegate {
    func didFetchPost() {
        refreshControl.endRefreshing()
    }
    
    func didFetchPostFailed(_ error: Error) {
        refreshControl.endRefreshing()
    }
}

extension PostVC {
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
