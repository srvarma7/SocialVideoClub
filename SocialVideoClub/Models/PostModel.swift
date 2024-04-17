//
//  PostModel.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 16/04/24.
//

import Foundation

struct FeedResponse: Decodable {
    let posts: [PostModel]
    
    enum CodingKeys: String, CodingKey {
        case posts = "data"
    }
}

struct PostModel: Decodable {
    let likes: Int
    let postId: String
    let profile_image: String
    let thumbnail_url: String
    let username: String
    let videoUrl: String
}
