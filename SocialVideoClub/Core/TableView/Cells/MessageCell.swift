//
//  MessageCell.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 19/04/24.
//

import UIKit
import EasyPeasy

final class MessageCell: UITableViewCell {
    static let height: CGFloat = 100
    static let id = MessageCell.description()
    
    lazy var messageImageView: UIImageView = {
        let iView = UIImageView()
        iView.tintColor = .gray
        return iView
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 10)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    lazy private var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [messageImageView, messageLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 0
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        contentView.backgroundColor = .brown
        
        setupViews()
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MessageCell {
    private func setupViews() {
        
        contentView.addSubview(stackView)
        stackView.easy.layout(
            CenterY(),
            Leading(),
            Trailing()
        )
        
        messageImageView.easy.layout(Size(15))
        messageLabel.easy.layout(Height(15))
    }
}
