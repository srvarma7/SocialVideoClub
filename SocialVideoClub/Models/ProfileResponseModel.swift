//
//  ProfileResponseModel.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 18/04/24.
//

import Foundation

struct ProfileResponseModel: Decodable {
    let profile: ProfileModel
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case profile = "data"
        case status
    }
}

struct ProfileModel: Decodable {
    let username: String
    let profilePictureUrl: String
    let posts: [PostModel]
}
