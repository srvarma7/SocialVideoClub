//
//  LoadingCell.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 19/04/24.
//

import UIKit
import EasyPeasy

final class LoadingCell: UITableViewCell {
    static let height: CGFloat = 100
    static let id = "LoadingCell"
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let aiView = UIActivityIndicatorView()
        return aiView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LoadingCell {
    private func setupViews() {
        contentView.addSubview(activityIndicator)
        activityIndicator.easy.layout(Center(), Size(30))
        activityIndicator.startAnimating()
    }
}
