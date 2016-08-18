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
    
    convenience init(url: NSURL) {
        self.init()
        play(url)
    }
    
    func play(url: NSURL) {
        player = AVPlayer(URL: url)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(playerDidFinishPlaying),
                                                         name: AVPlayerItemDidPlayToEndTimeNotification, object: player?.currentItem)
        player?.play()
    }
    
    func playerDidFinishPlaying(note: NSNotification) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
}
