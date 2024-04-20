//
//  FeedService.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 16/04/24.
//

import Foundation

enum FeedService {
    case feed(pageCount: Int)
}

extension FeedService: SocialClubServiceType {
    var path: String? {
        switch self {
            case .feed(let page):
                return "feed/posts\(page)"
        }
    }
    
    var method: ServiceMethod {
        switch self {
            case .feed:
                return .get
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
}
