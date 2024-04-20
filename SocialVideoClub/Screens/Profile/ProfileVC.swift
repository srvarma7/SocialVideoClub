//
//  ProfileVC.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 18/04/24.
//

import UIKit
import EasyPeasy

class ProfileVC: TableViewFeedVC {
    
    weak var coordinator: MainCoordinator?
    
    let viewModel: ProfileViewModel
    
    var profileHeader: ProfileHeaderView = ProfileHeaderView(frame: .zero)
    
    override var shouldAddScrollObserver: Bool {
        return true
    }
    
    override var tableViewStyle: UITableView.Style {
        return .grouped
    }
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        viewModel.fetchProfile()
    }
    
    override func registerTableViewCells() {
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.id)
    }
    
    var tableHeaderHeight: CGFloat {
        return view.frame.width/2
    }
    
    override func scrollOffsetDidChange(contentOffset: CGPoint) {
        print(contentOffset.y)
        title = contentOffset.y > tableHeaderHeight/1.2 ? viewModel.profileName : ""
        VideoAutoPlayManager.handle(cv: tableView)
    }
}

extension ProfileVC: ProfileViewModelDelegate {
    func didFetchProfile() {
        tableView.reloadData()
        refreshControl.endRefreshing()
        
        if let profile = viewModel.profile {
            profileHeader.name.text = profile.username
            if let url = URL(string: profile.profilePictureUrl) {
                profileHeader.profileImageView.setImage(with: url)
            }
        }
    }
}

extension ProfileVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.profile?.posts.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let videoCell = tableView.dequeueReusableCell(withIdentifier: PostCell.id, for: indexPath) as? PostCell else {
            
            return UITableViewCell()
        }
        
        if let post = viewModel.profile?.posts[indexPath.row] {
            videoCell.bind(post, location: .profile)
        }
        
        return videoCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return profileHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let post = viewModel.profile?.posts[indexPath.row] {
            coordinator?.showPost(post: post)
        }
    }
}

import SwiftUI

#Preview {
    let navVC = UINavigationController(rootViewController: ProfileVC(viewModel: ProfileViewModel(name: "sai")))
    return navVC
}
