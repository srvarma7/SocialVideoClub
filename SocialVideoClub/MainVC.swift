//
//  MainVC.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 16/04/24.
//

import UIKit

class MainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .brown
        title = "Social Club"
        
        Task {
//            await posts()
            await profile(username: "sai.json")
        }
    }
    
    func posts() async {
        let net = NetworkProvider<FeedService>()
        let result = await net.request(FeedService.feed, callbackQueue: DispatchQueue.main)
        
        switch result {
            case .success(let (data, _)):
                print(String(decoding: data, as: UTF8.self))
                
                // move decoding separate
                do {
                    let decoded = try JSONDecoder().decode(FeedResponse.self, from: data)
                    print(decoded.posts.first!.likes)
                } catch {
                    print(error)
                }
            case .failure(let failure):
                print(failure)
        }
    }
    
    func profile(username: String) async {
        let net = NetworkProvider<ProfileService>()
        let result = await net.request(.profileViaName(username), callbackQueue: DispatchQueue.main)
        
        switch result {
            case .success(let (data, _)):
                print(String(decoding: data, as: UTF8.self))
                
//                do {
//                    let decoded = try JSONDecoder().decode(FeedResponse.self, from: success)
//                    print(decoded.posts.first?.likes)
//                } catch {
//                    print(error)
//                }
            case .failure(let failure):
                print(failure)
        }
    }
    
}

import SwiftUI

#Preview {
    let navVC = UINavigationController(rootViewController: MainVC())
    return navVC
}
