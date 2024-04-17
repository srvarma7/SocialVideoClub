//
//  SocialClubServiceType.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 17/04/24.
//

import Foundation

protocol SocialClubServiceType: ProviderServiceType { 
    
}

extension SocialClubServiceType {
    var baseURL: String {
        return "https://srvarma7.github.io/SocialClubAPI/api"
    }
    
    var headers: [String: String]? { nil }
}
