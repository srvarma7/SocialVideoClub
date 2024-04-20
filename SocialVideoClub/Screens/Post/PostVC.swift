//
//  PostVC.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 17/04/24.
//

import UIKit

class PostVC: TableViewFeedVC {
    
    weak var coordinator: MainCoordinator?
    
    let viewModel: PostViewModel
    
    override var shouldAddScrollObserver: Bool {
        return true
    }
    
    init(viewModel: PostViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Post"
        
        viewModel.delegate = self
        viewModel.fetchPost()
    }
    
    override func registerTableViewCells() {
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.id)
    }
    
    override func scrollOffsetDidChange(contentOffset: CGPoint) {
        VideoAutoPlayManager.handle(cv: tableView)
    }
}

extension PostVC: PostViewModelDelegate {
    func didFetchPost() {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}

extension PostVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let videoCell = tableView.dequeueReusableCell(withIdentifier: PostCell.id, for: indexPath) as? PostCell else {
            return UITableViewCell()
        }
        
        videoCell.delegate = self
        let post = viewModel.posts[indexPath.row]
        videoCell.bind(post, location: .post)
        
        return videoCell
    }
}

extension PostVC: VideoCellDelegate {
    func showProfile(name: String) {
        coordinator?.showProfile(name: name)
    }
}

import SwiftUI

#Preview {
    let navVC = UINavigationController(rootViewController: HomeFeedVC())
    return navVC
}
