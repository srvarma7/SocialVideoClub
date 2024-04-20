//
//  ProfileViewModel.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 18/04/24.
//

import Foundation

protocol ProfileViewModelDelegate: AnyObject {
    func didFetchProfile()
}

class ProfileViewModel {
    weak var delegate: ProfileViewModelDelegate?
    
    let service: ProfileServiceManageable
    
    var profile: ProfileModel?
    
    private (set) var profileName: String
    
    /// Navigating from Feed
    init(name: String, service: ProfileServiceManageable = ProfileServiceManager()) {
        self.profileName = name
        self.service = service
    }
    
    func fetchProfile() {
        DispatchQueue.global().async { [weak self] in
            guard let self else {
                return
            }
            
            self.service.fetchProfile(name: profileName) { result in
                switch result {
                    case .success(let profileResult):
                        self.profile = profileResult
                        self.delegate?.didFetchProfile()
                    case .failure(let failure):
                        print(failure)
                }
            }
        }
    }
    
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

