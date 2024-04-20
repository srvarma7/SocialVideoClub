//
//  ClubBaseTableViewVC+VideoCellDelegate.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 20/04/24.
//

import Foundation

extension ClubBaseTableViewVC: VideoCellDelegate {
    @objc func showProfile(name: String) {
        
    }
    
    @objc func cellDisplayLocation() -> ScreenLocation {
        return .feed
    }
}
