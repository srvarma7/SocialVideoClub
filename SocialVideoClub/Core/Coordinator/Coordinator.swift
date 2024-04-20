//
//  Coordinator.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 18/04/24.
//

import UIKit

protocol Coordinator: AnyObject {
    var nav: UINavigationController { get set }
    
    func start()
}
