//
//  PostViewModel.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 17/04/24.
//

import Foundation

import OSLog
private let logger = Logger(subsystem: "com.SocialClub", category: "PostViewModel")

protocol PostViewModelDelegate: AnyObject {
    func didFetchPost()
}

class PostViewModel: TableBindableViewModel {
    weak var dataSource: ClubTableViewDataSource?
    
    weak var delegate: PostViewModelDelegate?
    
    let service: PostServiceManageable
    
    let postId: String
    private (set) var _post: PostModel?
    /// In future, if we were to send similar or trending posts. its possible with array instead of single object handling
    private var _posts: [PostModel] {
        if let _post {
            return [_post]
        } else {
            return []
        }
    }
    var objects: [Any] = []
    
    
    // MARK: - Flags
    
    
    private (set) var isRefreshing: Bool = false
    private (set) var isFetching: Bool = false
    private var isNetworkConnectionError = false
    
    /// Navigating from Feed when post object is available
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
    
    func refreshPost() {
        isRefreshing = true
        fetchPost()
    }
    
    func fetchPost() {
        guard isFetching == false else {
            return
        }
        
        isFetching = true
        updateObject()
        
        DispatchQueue.global().async { [weak self] in
            guard let self else {
                return
            }
            
            self.service.fetchPost(id: postId) { result in
                
                self.isRefreshing = false
                self.isFetching = false
                self.isNetworkConnectionError = false
                
                switch result {
                    case .success(let postResult):
                        self._post = postResult
                        self.delegate?.didFetchPost()
                    case .failure(let failure):
                        let error = failure as NSError
                        self.isNetworkConnectionError = error.code == -1009
                        logger.error("\(error.localizedDescription)")
                }
                
                self.updateObject(animated: false)
            }
        }
    }
    
    func updateObject(animated: Bool = true) {
        var newObjects: [Any] = []

        if isRefreshing {
            newObjects.append(FeedToken.isLoading)
        }
        
        if !_posts.isEmpty {
            newObjects.append(contentsOf: _posts)
        }
        
        if isFetching, !isRefreshing {
            newObjects.append(FeedToken.isLoading)
        }
        
        if isNetworkConnectionError {
            newObjects.append(FeedToken.networkError)
        }
        
        self.objects = newObjects
        
        dataSource?.update(objects: objects, animated: animated)
    }
    
}

extension PostViewModel {
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
