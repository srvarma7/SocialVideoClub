//
//  Tokens.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 19/04/24.
//

import UIKit

enum Tokens {
    case isLoading
//    case isRefreshing     = "List.isRefreshing"
    case hasNoMoreFeed
    case networkError
    
    var description: String {
        switch self {
            case .isLoading      : return "List.isLoading"
//            case .isRefreshing   : return "List.isRefreshing"
            case .hasNoMoreFeed  : return "All caught up"
            case .networkError   : return "Network issue"
        }
    }
    
    var image: UIImage? {
        switch self {
            case .isLoading      : return nil
//            case .isRefreshing   : return nil
            case .hasNoMoreFeed  : return UIImage(systemName: "figure.walk.motion")
            case .networkError  : return UIImage(systemName: "icloud.slash")
        }
    }
}
