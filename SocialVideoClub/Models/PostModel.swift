//
//  PostModel.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 16/04/24.
//

import Foundation

struct PostModel: Decodable, Hashable, Identifiable, Equatable {
    var id: String {
        return postId
    }
    
    var likes: Int
    let postId: String
    let profile_image: String?
    let thumbnail_url: String
    let username: String?
    let videoUrl: String
}
