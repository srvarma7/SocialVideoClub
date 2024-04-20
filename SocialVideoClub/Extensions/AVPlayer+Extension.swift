//
//  AVPlayer+Extension.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 17/04/24.
//

import AVKit

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
