//
//  FeedNetworkManager.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 17/04/24.
//

import Foundation

protocol FeedNetworkManageable {
    func fetchFeed() async -> Result<[PostModel], Error>
    func fetchNewFeed()
    func fetchNextFeed(page: Int)
}

class FeedNetworkManager: FeedNetworkManageable {
    
    let networkProvider: NetworkProvider<FeedService>
    let responseHandler: ResponseHandler
    
    init(
        networkProvider: NetworkProvider<FeedService> = NetworkProvider<FeedService>(),
        responseHandler: ResponseHandler = ResponseHandler()
    ) {
        self.networkProvider = networkProvider
        self.responseHandler = responseHandler
    }
    
    func fetchFeed() async -> Result<[PostModel], Error> {
        let result = await networkProvider.request(.feed, callbackQueue: .main)
        switch result {
            case .success(let (data, urlResponse)):
                let parsedDataResult = responseHandler.decode(type: FeedResponse.self, data: data)
                switch parsedDataResult {
                    case .success(let feed):
                        return .success(feed.posts)
                    case .failure(let failure):
                        return .failure(failure)
                }
            case .failure(let failure):
                return .failure(failure)
        }
    }
    
    func fetchNewFeed() {
        
    }
    
    func fetchNextFeed(page: Int) {
        
    }
}
