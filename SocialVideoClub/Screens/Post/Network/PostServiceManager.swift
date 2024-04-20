//
//  PostServiceManager.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 17/04/24.
//

import Foundation

protocol PostServiceManageable {
    func fetchPost(id: String, completion: @escaping (Result<PostModel, Error>) -> Void)
//    func fetchPost(id: String) async -> Result<PostModel, Error>
}

class PostServiceManager: PostServiceManageable {
    
    let networkProvider: NetworkProvider<PostService>
    let responseHandler: ResponseHandler
    
    init(
        networkProvider: NetworkProvider<PostService> = NetworkProvider<PostService>(),
        responseHandler: ResponseHandler = ResponseHandler()
    ) {
        self.networkProvider = networkProvider
        self.responseHandler = responseHandler
    }
    
    func fetchPost(id: String, completion: @escaping (Result<PostModel, Error>) -> Void) {
        networkProvider.request(.post(id), callbackQueue: .main) { [weak self] result in
            guard let self else {
                completion(.failure(NSError(domain: "self unavailable", code: 404)))
                return
            }
            switch result {
                case .success(let (data, _)):
                    let parsedDataResult = self.responseHandler.decode(type: PostResponseModel.self, data: data)
                    switch parsedDataResult {
                        case .success(let response):
                            completion(.success(response.post))
                        case .failure(let failure):
                            completion(.failure(failure))
                    }
                case .failure(let failure):
                    completion(.failure(failure))
            }
        }
    }
    
    //    /// Using async/await
    //    func fetchPost(id: String) async -> Result<PostModel, Error> {
    //        let result = await networkProvider.request(.post(id), callbackQueue: .main)
    //        switch result {
    //            case .success(let (data, _)):
    //                let parsedDataResult = responseHandler.decode(type: PostResponseModel.self, data: data)
    //                switch parsedDataResult {
    //                    case .success(let response):
    //                        return .success(response.post)
    //                    case .failure(let failure):
    //                        return .failure(failure)
    //                }
    //            case .failure(let failure):
    //                return .failure(failure)
    //        }
    //    }
}
