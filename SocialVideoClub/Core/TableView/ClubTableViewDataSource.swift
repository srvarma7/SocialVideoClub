//
//  ClubTableViewDataSource.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 20/04/24.
//

import UIKit

class ClubTableViewDataSource: UITableViewDiffableDataSource<Section, Row> {
    
    init(tableView: UITableView, cellDelegate: AnyObject?) {
        super.init(tableView: tableView) { tableView, indexPath, item in
            switch item {
                case .post(let post):
                    let postCell = tableView.dequeueReusableCell(withIdentifier: PostCell.id, for: indexPath) as! PostCell
                    if let delegate = cellDelegate as? VideoCellDelegate {
                        postCell.delegate = delegate
                    }
                    postCell.bind(post)
                    return postCell
                    
                case .message(let token):
                    if token == Tokens.isLoading {
                        let loadingCell = tableView.dequeueReusableCell(withIdentifier: LoadingCell.id, for: indexPath) as! LoadingCell
                        return loadingCell
                    }
                    
                    if token == Tokens.hasNoMoreFeed || token == Tokens.networkError {
                        let messageCell = tableView.dequeueReusableCell(withIdentifier: MessageCell.id, for: indexPath) as! MessageCell
                        messageCell.messageImageView.image  = token.image
                        messageCell.messageLabel.text       = token.description
                        return messageCell
                    }
            }
            
            return UITableViewCell()
        }
    }
        
    func update(objects: [Any], animated: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Row>()
        snapshot.appendSections([.post, .message])
        for object in objects {
            if let post = object as? PostModel {
                snapshot.appendItems([Row.post(post)], toSection: .post)
            }
            
            if let message = object as? Tokens {
                snapshot.appendItems([Row.message(message)], toSection: .message)
            }
        }
        
        apply(snapshot, animatingDifferences: animated)
    }
}
