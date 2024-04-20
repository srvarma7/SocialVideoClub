//
//  PostService.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 16/04/24.
//

import Foundation

enum PostService {
    case post(_ id: String)
//    case likePost(_ id: String)
}

extension PostService: SocialClubServiceType {
    var path: String? {
        switch self {
            case .post(let id):
                return "post/\(id)"
        }
    }
    
    var method: ServiceMethod {
        return .get
    }
}
