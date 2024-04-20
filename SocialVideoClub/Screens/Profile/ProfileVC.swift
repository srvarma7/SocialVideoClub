//
//  ProfileVC.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 18/04/24.
//

import UIKit
import EasyPeasy

class ProfileVC: ClubBaseTableViewVC {
    
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
        viewModel.dataSource = dataSource
        viewModel.fetchProfile()
    }
    
    override func didPullToRefresh() {
        viewModel.refresh()
    }
    
    @objc override func cellDisplayLocation() -> ScreenLocation {
        return .profile
    }
    
    var tableHeaderHeight: CGFloat {
        return view.frame.width/2
    }
    
    override func scrollOffsetDidChange(contentOffset: CGPoint) {
        super.scrollOffsetDidChange(contentOffset: contentOffset)
        
        title = contentOffset.y > tableHeaderHeight/1.2 ? viewModel.profileName : ""
    }
}

extension ProfileVC: ProfileViewModelDelegate {
    func didFetchProfile(_ profile: ProfileModel) {
        refreshControl.endRefreshing()
        
        profileHeader.name.text = profile.username
        if let url = URL(string: profile.profilePictureUrl) {
            profileHeader.profileImageView.setImage(with: url)
        }
    }
    
    func profileFetchError() {
        refreshControl.endRefreshing()
    }
}

extension ProfileVC {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 0 ? profileHeader : nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableHeaderHeight
    }
    
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

//import SwiftUI
//
//#Preview {
//    let navVC = UINavigationController(rootViewController: ProfileVC(viewModel: ProfileViewModel(name: "sai")))
//    return navVC
//}
