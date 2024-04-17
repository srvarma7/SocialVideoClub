//
//  FeedService.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 16/04/24.
//

import Foundation

enum FeedService {
    case feed
    case hasNewFeed(firstPostId: String)
    case newFeed(firstPostId: String)
    case nextFeed(pageCount: Int)
}

extension FeedService: SocialClubServiceType {
    /*
     var baseURL: String {
     //        return "https://api.jsonbin.io/v3/b/661e9a94e41b4d34e4e54a1d"
     //        return "https://jsonkeeper.com/b/9GOF"
     //        return "https://api.npoint.io/cf9bd76b5d9c3bc4f224"
     //        return "https://srvarma7.github.io/SocialClubAPI/api/feed/posts"
     //        return "https://srvarma7.github.io/SocialClubAPI/api/feed/posts.json"
     return "https://srvarma7.github.io/SocialClubAPI/api"
     }
     */
    
    var path: String? {
        switch self {
            case .feed:
                return "feed/posts"
            case .hasNewFeed:
                return "feed/posts"
            case .newFeed:
                return "feed/posts"
            case .nextFeed:
                return "feed/posts"
        }
    }
    
    var method: ServiceMethod {
        switch self {
            case .feed, .hasNewFeed, .newFeed, .nextFeed:
                return .get
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
}
