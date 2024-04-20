//
//  ProfileServiceManager.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 18/04/24.
//

import Foundation

protocol ProfileServiceManageable {
//    func fetchProfile(name: String) async -> Result<ProfileModel, Error>
    func fetchProfile(name: String, completion: @escaping (Result<ProfileModel, Error>) -> Void)
}

class ProfileServiceManager: ProfileServiceManageable {
    
    let networkProvider: NetworkProvider<ProfileService>
    let responseHandler: ResponseHandler
    
    init(
        networkProvider: NetworkProvider<ProfileService> = NetworkProvider<ProfileService>(),
        responseHandler: ResponseHandler = ResponseHandler()
    ) {
        self.networkProvider = networkProvider
        self.responseHandler = responseHandler
    }
    
    func fetchProfile(name: String, completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        networkProvider.request(.profileViaName(name), callbackQueue: .main) { [weak self] result in
            guard let self else {
                completion(.failure(NSError(domain: "self unavailable", code: 404)))
                return
            }
            switch result {
                case .success(let (data, _)):
                    let parsedDataResult = self.responseHandler.decode(type: ProfileResponseModel.self, data: data)
                    switch parsedDataResult {
                        case .success(let response):
                            completion(.success(response.profile))
                        case .failure(let failure):
                            completion(.failure(failure))
                    }
                case .failure(let failure):
                    completion(.failure(failure))
            }
        }
    }
    
    //    /// Using async/await
    //    func fetchProfile(name: String) async -> Result<ProfileModel, Error> {
    //        let result = await networkProvider.request(.profileViaName(name), callbackQueue: .main)
    //        switch result {
    //            case .success(let (data, _)):
    //                let parsedDataResult = responseHandler.decode(type: ProfileResponseModel.self, data: data)
    //                switch parsedDataResult {
    //                    case .success(let response):
    //                        return .success(response.profile)
    //                    case .failure(let failure):
    //                        return .failure(failure)
    //                }
    //            case .failure(let failure):
    //                return .failure(failure)
    //        }
    //    }

}
