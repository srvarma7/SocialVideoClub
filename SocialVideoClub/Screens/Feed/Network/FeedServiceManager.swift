//
//  FeedServiceManager.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 17/04/24.
//

import Foundation

protocol FeedServiceManageable {
//    func fetchFeed(page: Int) async -> Result<[PostModel], Error>
    func fetchFeed(page: Int, completion: @escaping (Result<[PostModel], Error>) -> Void)
}

class FeedServiceManager: FeedServiceManageable {
    
    let networkProvider: NetworkProvider<FeedService>
    let responseHandler: ResponseHandler
    
    init(
        networkProvider: NetworkProvider<FeedService> = NetworkProvider<FeedService>(),
        responseHandler: ResponseHandler = ResponseHandler()
    ) {
        self.networkProvider = networkProvider
        self.responseHandler = responseHandler
    }
    
    func fetchFeed(page: Int, completion: @escaping (Result<[PostModel], Error>) -> Void) {
        networkProvider.request(.feed(pageCount: page), callbackQueue: .main) { [weak self] result in
            guard let self else {
                completion(.failure(NSError(domain: "self unavailable", code: 404)))
                return
            }
            switch result {
                case .success(let (data, _)):
                    let parsedDataResult = self.responseHandler.decode(type: FeedResponse.self, data: data)
                    switch parsedDataResult {
                        case .success(let response):
                            completion(.success(response.posts))
                        case .failure(let failure):
                            completion(.failure(failure))
                    }
                case .failure(let failure):
                    completion(.failure(failure))
            }
        }
    }
}

//extension FeedServiceManager {
//    /// Using async/await
//    func fetchFeed(page: Int) async -> Result<[PostModel], Error> {
//        let result = await networkProvider.request(.feed(pageCount: page), callbackQueue: .main)
//        switch result {
//            case .success(let (data, _)):
//                let parsedDataResult = responseHandler.decode(type: FeedResponse.self, data: data)
//                switch parsedDataResult {
//                    case .success(let feed):
//                        if feed.status.lowercased() == "success" {
//                            return .success(feed.posts)
//                        } else {
//                            return .failure(NSError(domain: "Invalid status \(feed.status)", code: 400))
//                        }
//                    case .failure(let failure):
//                        return .failure(failure)
//                }
//            case .failure(let failure):
//                return .failure(failure)
//        }
//    }
//}
