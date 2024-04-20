//
//  ClubTableViewDataSource.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 20/04/24.
//

import UIKit

enum Section: Hashable {
    case post
    case message
}

// This helps in scaling the app to support different widgets and various other posts kind like Image, Suggestion, Advertisement, etc.
enum Row: Hashable {
    case post(PostModel)
    case message(FeedToken)
}

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
                    if token == FeedToken.isLoading {
                        let loadingCell = tableView.dequeueReusableCell(withIdentifier: LoadingCell.id, for: indexPath) as! LoadingCell
                        return loadingCell
                    } else if token.isMessage {
                        let messageCell = tableView.dequeueReusableCell(withIdentifier: MessageCell.id, for: indexPath) as! MessageCell
                        messageCell.messageImageView.image  = token.image
                        messageCell.messageLabel.text       = token.description
                        return messageCell
                    } else {
                        assertionFailure("Unknown kind. Cell not provided")
                    }
            }
            
            return UITableViewCell()
        }
    }
    
    // Converts the objects to sections & rows and applies changes to tableview
    func update(objects: [Any], animated: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Row>()
        snapshot.appendSections([.post, .message])
        for object in objects {
            if let post = object as? PostModel {
                snapshot.appendItems([Row.post(post)], toSection: .post)
            }
            
            if let message = object as? FeedToken {
                snapshot.appendItems([Row.message(message)], toSection: .message)
            }
        }
        
        DispatchQueue.main.async {
            self.apply(snapshot, animatingDifferences: animated)
        }
    }
}
