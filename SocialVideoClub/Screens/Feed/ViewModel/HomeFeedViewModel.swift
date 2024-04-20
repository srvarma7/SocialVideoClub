//
//  HomeFeedViewModel.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 17/04/24.
//

import Foundation

import OSLog
private let logger = Logger(subsystem: "com.SocialVideoClub", category: "HomeFeedViewModel")

protocol HomeFeedDelegate: AnyObject {
    func didFetchFeed()
    func didFetchFeedFailed()
}

class HomeFeedViewModel {
    weak var delegate: HomeFeedDelegate?
    
    let feedService: FeedServiceManageable
    
    var objects: [Any] = []
    private var hasMoreFeed = true
    private var networkError = false
    
    
    private var _posts: [PostModel] = []
    private var pageCount = 0
    private (set) var isFetching: Bool = false
    
    init(feedService: FeedServiceManageable = FeedServiceManager()) {
        self.feedService = feedService
    }
    
    func fetchLatestFeed() {
        pageCount = 0
        hasMoreFeed = true
        fetchPosts()
    }
    
    func fetchPosts() {
        guard isFetching == false && hasMoreFeed else {
            return
        }
        
        isFetching = true
        updateObjects()
        DispatchQueue.global().async { [weak self] in
            guard let self else {
                return
            }
            
            self.feedService.fetchNextFeed(page: pageCount) { result in
                self.isFetching = false
                self.networkError = false
                switch result {
                    case .success(let newPosts):
                        if self.pageCount == 0 {
                            self._posts = newPosts
                        } else {
                            self._posts.append(contentsOf: newPosts)
                        }
                        
                        if newPosts.isEmpty {
                            self.hasMoreFeed = false
                        } else {
                            self.hasMoreFeed = true
                            self.pageCount += 1
                        }
                        
                        self.updateObjects()
                        self.delegate?.didFetchFeed()
                    case .failure(let failure):
                        logger.error("\(failure.localizedDescription)")
                        self.networkError = true
                        self.updateObjects()
                        self.delegate?.didFetchFeedFailed()
                }
                
            }
        }
    }
    
    func updateObjects() {
        var newObjects: [Any] = []
        
        if !_posts.isEmpty {
            newObjects.append(contentsOf: _posts)
        }
        
        if isFetching {
            newObjects.append(Tokens.isLoading)
        }
        
        if hasMoreFeed == false {
            newObjects.append(Tokens.hasNoMoreFeed)
        }
        
        if networkError {
            newObjects.append(Tokens.networkError)
        }
        
        self.objects = newObjects
    }
    
//    /// Using async/await
//    func fetchPosts() {
//        guard isFetching == false else {
//            return
//        }
//        
//        isFetching = true
//        
//        DispatchQueue.global().async {
//            Task { [weak self] in
//                guard let self else {
//                    return
//                }
//                
//                let result = await self.feedService.fetchNextFeed(page: pageCount)
//                switch result {
//                    case .success(let newPosts):
//                        if pageCount == 0 {
//                            self.posts = newPosts
//                        } else {
//                            self.posts.append(contentsOf: newPosts)
//                        }
//                        pageCount += 1
//                        DispatchQueue.main.async {
//                            self.delegate?.didFetchFeed()
//                        }
//                    case .failure(let failure):
//                        print(failure)
//                        DispatchQueue.main.async {
//                            self.delegate?.didFetchFeedFailed()
//                        }
//                        
//                }
//                isFetching = false
//            }
//        }
//    }
}
