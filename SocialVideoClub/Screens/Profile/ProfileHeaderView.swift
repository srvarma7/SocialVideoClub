//
//  ProfileHeaderView.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 18/04/24.
//

import UIKit
import EasyPeasy

class ProfileHeaderView: UIView {
    
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 20
        iv.layer.masksToBounds = true
        //        iv.image = .test
        iv.contentMode = .scaleAspectFill
        iv.layer.shadowColor = UIColor.black.cgColor
        return iv
    }()
    
    lazy var name: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.easy.layout(
            Top(5),
            CenterX(),
            Size(170)
        )
        
        addSubview(name)
        name.easy.layout(Top(8).to(profileImageView), CenterX())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
