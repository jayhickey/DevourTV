//
//  DevourVideoEmitter.swift
//  Devour
//
//  Created by johnrhickey on 8/17/16.
//  Copyright © 2016 Jay Hickey. All rights reserved.
//

import Foundation

public enum DevourVideoType: String {
    case Latest = "Latest"
    case Popular = "Popular"
}

class DevourVideoSetEmitter: NSObject, VideoSetEmitter {
    let videoType: DevourVideoType
    var page: Int = 1
    
    init(videoType: DevourVideoType) {
        self.videoType = videoType
    }
    
    var title: String {
        return videoType.rawValue
    }
    
    var updateBlock: EmitterUpdateCallback?
    func onUpdate( callback: EmitterUpdateCallback ) {
        updateBlock = callback
    }
    
    var videos:[DevourVideo] = [] {
        didSet {
            updateBlock?(videos: videos)
        }
    }
    
    func videoAtIndexPath(index: NSIndexPath) -> DevourVideo {
        return videos[index.row]
    }
    
    var numberOfVideos: Int {
        return videos.count
    }
    
    func getVideos() {
        fetchDevourVideos(videoType, page: page) { newVideos in
            self.videos = self.videos + newVideos
        }
        page += 1
    }
}