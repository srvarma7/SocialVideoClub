//
//  VideoAutoPlayManager.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 17/04/24.
//

import UIKit

struct VideoAutoPlayManager {
    private init() { }
    
    private static let minVisiblePercentage: Int = 70
    
    /// Handles autoplay of VideoCell
    static func handle(cv tableView: UITableView) {
        let videoCells = getVideoCells(cv: tableView)
        
        // Pause video cell if visible per is less min requirement
        for cell in videoCells where cell.isPlaying() == true {
            if cell.visiblePercentageInSuperView() < minVisiblePercentage {
                cell.cellDidEndDisplay()
            }
        }
        
        _ = handleVideoCells(videoCells: videoCells)
    }
}


// MARK: - Helpers


extension VideoAutoPlayManager {
    private static func getVideoCells(cv tableView: UITableView) -> [PostCell] {
        let cells = tableView.visibleCells.compactMap({ $0 as? PostCell })
        return cells
    }
    
    private static func handleVideoCells(videoCells: [PostCell]) -> Bool {
        if videoCells.count > 1 {
            let cell1 = videoCells[0]
            let cell1VisiblePercentage = cell1.visiblePercentageInSuperView() // visiblePercentageInSuperView(of: cell1)
            
            let cell2 = videoCells[1]
            let cell2VisiblePercentage = cell2.visiblePercentageInSuperView()
            
            if cell1VisiblePercentage > minVisiblePercentage {                      // can play cell1
                if cell2VisiblePercentage > minVisiblePercentage {                  // can play cell2
                    if cell1VisiblePercentage > cell2VisiblePercentage {            // Play most visible cell
                        startVideoAutoPlay(cell: cell1)
                        return true
                    } else {
                        startVideoAutoPlay(cell: cell2)
                        return true
                    }
                    
                } else {
                    startVideoAutoPlay(cell: cell1)
                }
            } else if cell2VisiblePercentage > minVisiblePercentage {
                startVideoAutoPlay(cell: cell2)
                return true
            }
        } else if let cell = videoCells.first {                                     // One video cell available
            if cell.visiblePercentageInSuperView() > minVisiblePercentage {         // play if visible percentage is met
                startVideoAutoPlay(cell: cell)
                return true
            }
        }
        return false
    }
    
    private static func startVideoAutoPlay(cell: PostCell) {
        cell.startAutoPlay()
    }
}
