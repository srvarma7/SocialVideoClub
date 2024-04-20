//
//  UITableView+Extension.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 19/04/24.
//

import UIKit

extension UITableViewCell {
    func visiblePercentageInSuperView() -> Int {
        guard let cellSuperView = self.superview else {
            return 0
        }
        
        let cellFrame = self.frame
        let rect = cellSuperView.convert(cellFrame, from: cellSuperView)
        let intersection = rect.intersection(cellSuperView.bounds)
        let ratio = (intersection.width * intersection.height) / (cellFrame.width * cellFrame.height)
        
        guard !ratio.isNaN else {                                                   // Check if ratio is valid due to frame availability
            return 0
        }
        
        let visiblePercentage = Int(ratio * 100)
        return visiblePercentage
    }
}
