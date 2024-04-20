//
//  MainCoordinator.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 18/04/24.
//

import UIKit

final class MainCoordinator: Coordinator {
    
    var nav: UINavigationController
    
    init(nav: UINavigationController) {
        self.nav = nav
        nav.navigationBar.tintColor = .white
    }
    
    func start() {
        let feedVC = HomeFeedVC()
        feedVC.coordinator = self
        nav.setViewControllers([feedVC], animated: false)
    }
    
    func showPost(post: PostModel) {
        let vm = PostViewModel(post: post)
        let vc = PostVC(viewModel: vm)
        vc.coordinator = self
        nav.pushViewController(vc, animated: true)
    }
    
    func showProfile(name: String) {
        let vm = ProfileViewModel(name: name)
        let vc = ProfileVC(viewModel: vm)
        vc.coordinator = self
        nav.pushViewController(vc, animated: true)
    }
}
