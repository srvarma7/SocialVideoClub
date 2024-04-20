//
//  FeedToken.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 19/04/24.
//

import UIKit

enum FeedToken: Hashable {
    /// To show pagination loading UI/refresh
    case isLoading
    /// To show the end of feed when there is not more data from server
    case hasNoMoreFeed
    case networkError
    case noPosts
    
    var description: String {
        switch self {
            case .isLoading         : return ""
            case .hasNoMoreFeed     : return "All caught up"
            case .networkError      : return "Network issue"
            case .noPosts           : return "No posts"
        }
    }
    
    var image: UIImage? {
        switch self {
            case .isLoading         : return nil
            case .hasNoMoreFeed     : return UIImage(systemName: "figure.walk.motion")
            case .networkError      : return UIImage(systemName: "icloud.slash")
            case .noPosts           : return UIImage(systemName: "figure.climbing")
        }
    }
    
    var isMessage: Bool {
        switch self {
            case .isLoading:
                return false
            case .hasNoMoreFeed, .networkError, .noPosts:
                return true
        }
    }
}
