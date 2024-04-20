//
//  ProfileViewModel.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 18/04/24.
//

import Foundation

import OSLog
private let logger = Logger(subsystem: "com.SocialClub", category: "ProfileViewModel")

protocol ProfileViewModelDelegate: AnyObject {
    func didFetchProfile(_ profile: ProfileModel)
    func profileFetchError()
}

class ProfileViewModel: TableBindableViewModel {
    
    weak var dataSource: ClubTableViewDataSource?
    weak var delegate: ProfileViewModelDelegate?
    
    let service: ProfileServiceManageable
    
    var profile: ProfileModel?
    var objects: [Any] = []
    
    
    // MARK: - Flags
    
    
    private (set) var isRefreshing: Bool = false
    private (set) var isFetching: Bool = false
    private var isNetworkConnectionError = false
    
    private (set) var profileName: String
    
    /// Navigating from Feed
    init(name: String, service: ProfileServiceManageable = ProfileServiceManager()) {
        self.profileName = name
        self.service = service
    }
    
    func refresh() {
        isRefreshing = true
        fetchProfile()
    }
    
    func fetchProfile() {
        guard isFetching == false else {
            return
        }
        
        isFetching = true
        updateObject()
        
        DispatchQueue.global().async { [weak self] in
            guard let self else {
                return
            }
            
            self.service.fetchProfile(name: profileName) { result in
                
                self.isRefreshing = false
                self.isFetching = false
                self.isNetworkConnectionError = false
                
                switch result {
                    case .success(let profileResult):
                        self.profile = profileResult
                        self.delegate?.didFetchProfile(profileResult)
                    case .failure(let failure):
                        let error = failure as NSError
                        self.isNetworkConnectionError = error.code == -1009
                        logger.error("\(error.localizedDescription)")
                        self.delegate?.profileFetchError()
                }
                
                self.updateObject()
            }
        }
    }
    
    func updateObject(animated: Bool = true) {
        var newObjects: [Any] = []
        
        if isRefreshing {
            newObjects.append(FeedToken.isLoading)
        }
        
        if let profile {
            newObjects.append(contentsOf: profile.posts)
        }
        
        if isFetching, !isRefreshing {
            newObjects.append(FeedToken.isLoading)
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

extension ProfileViewModel {
    //    /// Using async/await
    //    func fetchProfile() {
    //        DispatchQueue.global().async {
    //            Task { [weak self] in
    //                guard let self else {
    //                    return
    //                }
    //
    //                let result = await self.service.fetchProfile(name: profileName)
    //                switch result {
    //                    case .success(let profileResult):
    //                        self.profile = profileResult
    //                        DispatchQueue.main.async {
    //                            self.delegate?.didFetchProfile()
    //                        }
    //                    case .failure(let failure):
    //                        print(failure)
    //                }
    //            }
    //        }
    //    }
}
