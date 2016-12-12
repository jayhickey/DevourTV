//
//  PlayerViewController.swift
//  Devour
//
//  Created by johnrhickey on 8/17/16.
//  Copyright © 2016 Jay Hickey. All rights reserved.
//

import Foundation
import UIKit
import AVKit

class VideoViewController: AVPlayerViewController, AVPlayerViewControllerDelegate {
    
    convenience init(url: URL) {
        self.init()
        play(url)
    }
    
    func play(_ url: URL) {
        player = AVPlayer(url: url)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying),
                                                         name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        player?.play()
    }
    
    func playerDidFinishPlaying(_ note: Notification) {
        self.dismiss(animated: true, completion: nil)
    }

    
}
