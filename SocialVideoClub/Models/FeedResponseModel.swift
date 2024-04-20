//
//  FeedResponse.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 18/04/24.
//

import Foundation

struct FeedResponse: Decodable {
    let posts: [PostModel]
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case posts = "data"
        case status
    }
}
