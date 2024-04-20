//
//  ProfileService.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 16/04/24.
//

import Foundation

enum ProfileService {
    case profileViaName(_ username: String)
//    case profileViaId(_ id: String)
}

extension ProfileService: SocialClubServiceType {
    var path: String? {
        switch self {
            case .profileViaName(let username):
                return "profile/\(username)"
        }
    }
    
    var method: ServiceMethod {
        switch self {
            case .profileViaName:
                return .get
        }
    }
}
