//
//  PostViewModel.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 17/04/24.
//

import Foundation

protocol PostViewModelDelegate: AnyObject {
    func didFetchPost()
}

class PostViewModel {
    weak var delegate: PostViewModelDelegate?
    
    let service: PostServiceManageable
    
    let postId: String
    private var _post: PostModel?
    
    /// In future, if we were to send similar or trending posts. its possible with array instead of single object handling
    var posts: [PostModel] {
        if let _post {
            return [_post]
        } else {
            return []
        }
    }
    
    /// Navigating from Feed
    init(post: PostModel, service: PostServiceManageable = PostServiceManager()) {
        self.postId = post.postId
        self._post = post
        self.service = service
    }
    
    /// Can be used for Deeplink
    init(postId: String, service: PostServiceManageable = PostServiceManager()) {
        self.postId = postId
        self._post = nil
        self.service = service
    }
    
    func fetchPost() {
        DispatchQueue.global().async { [weak self] in
            guard let self else {
                return
            }
            
            self.service.fetchPost(id: postId) { result in
                switch result {
                    case .success(let postResult):
                        self._post = postResult
                        DispatchQueue.main.async {
                            self.delegate?.didFetchPost()
                        }
                    case .failure(let failure):
                        print(failure)
                }
            }
        }
    }
    
//    /// Using async/await
//    func fetchPost() {
//        DispatchQueue.global().async {
//            Task { [weak self] in
//                guard let self else {
//                    return
//                }
//                
//                let result = await self.service.fetchPost(id: postId)
//                switch result {
//                    case .success(let postResult):
//                        self._post = postResult
//                        DispatchQueue.main.async {
//                            self.delegate?.didFetchPost()
//                        }
//                    case .failure(let failure):
//                        print(failure)
//                }
//            }
//        }
//    }
}
