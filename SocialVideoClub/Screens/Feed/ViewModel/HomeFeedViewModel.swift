//
//  HomeFeedViewModel.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 17/04/24.
//

import UIKit

import OSLog
private let logger = Logger(subsystem: "com.SocialVideoClub", category: "HomeFeedViewModel")

protocol HomeFeedDelegate: AnyObject {
    func didFetchFeed()
    func didFetchFeedFailed()
}

protocol TableBindableViewModel {
    var dataSource: ClubTableViewDataSource? { get }
    func updateObject(animated: Bool)
}

class HomeFeedViewModel: TableBindableViewModel {
    
    weak var dataSource: ClubTableViewDataSource?
    weak var delegate: HomeFeedDelegate?
    
    var objects: [Any] = []
    private (set) var _posts: [PostModel] = []
    
    private var pageCount = 0
    
    
    // MARK: - Flags
    
    
    private (set) var isFetching: Bool = false
    private var hasMoreFeed = true
    private var isNetworkConnectionError = false
    
    let feedService: FeedServiceManageable
    
    init(feedService: FeedServiceManageable = FeedServiceManager()) {
        self.feedService = feedService
    }
    
    func fetchLatestFeed() {
        pageCount = 0
        hasMoreFeed = true
        fetchPosts()
    }
    
    /// Fetch posts and paginate calls
    func fetchPosts() {
        guard isFetching == false && hasMoreFeed else {                            // Avoid duplicate requests while one is active.
            return
        }
        
        isFetching = true
        updateObject()
        DispatchQueue.global().async { [weak self] in
            guard let self else {
                return
            }
            
            self.feedService.fetchFeed(page: pageCount) { result in
                self.isFetching = false
                self.isNetworkConnectionError = false
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
                        
                        self.delegate?.didFetchFeed()
                    case .failure(let failure):
                        let error = failure as NSError
                        self.isNetworkConnectionError = error.code == -1009
                        logger.error("\(error.localizedDescription)")
                        self.delegate?.didFetchFeedFailed()
                }
                
                self.updateObject()
            }
        }
    }
    
    func updateObject(animated: Bool = true) {
        var newObjects: [Any] = []
        
        if !_posts.isEmpty {
            newObjects.append(contentsOf: _posts)
        }
        
        if isFetching {
            newObjects.append(FeedToken.isLoading)
        }
        
        if hasMoreFeed == false {
            newObjects.append(FeedToken.hasNoMoreFeed)
        }
        
        if isNetworkConnectionError {
            newObjects.append(FeedToken.networkError)
        }
        
        if newObjects.isEmpty {
            newObjects.append(FeedToken.noPosts)
        }
        
        self.objects = newObjects
        
        dataSource?.update(objects: objects)
    }
}

//extension HomeFeedViewModel {
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
//                let result = await self.feedService.fetchFeed(page: pageCount)
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
//}
