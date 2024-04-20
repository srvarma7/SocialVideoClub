//
//  PostResponseModel.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 18/04/24.
//

import Foundation

struct PostResponseModel: Decodable {
    let post: PostModel
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case post = "data"
        case status
    }
}
