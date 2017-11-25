//
//  YouTubeParser.swift
//  Devour
//
//  Created by johnrhickey on 8/17/16.
//  Copyright © 2016 Jay Hickey. All rights reserved.
//

import Foundation

public enum VideoQuality: Int {
    case hd = 0
    case sd
}

public struct YouTubeVideo {
    let URL           : URL
    let quality       : VideoQuality
    let qualityString : String
}

public func videos(_ id: String) -> [YouTubeVideo] {
    var videos = [YouTubeVideo]()
    
    let videosDict = HCYoutubeParser.h264videos(withYoutubeID: id)
    for key in qualityKeys(id) {
        if let urlString = videosDict?[key] as? String, let videoURL = URL(string: urlString) {
            let video = YouTubeVideo(URL: videoURL, quality: (key == "hd720") ? .hd : .sd, qualityString: key)
            videos.append(video)
        }
    }
    return videos
}

// MARK: Private

private func qualityKeys(_ id: String) -> [String] {
    let videos = HCYoutubeParser.h264videos(withYoutubeID: id)
    guard let unwrappedVideos = videos else {
        return [String]()
    }
    
    let keys = Array(unwrappedVideos.keys).map{ String(describing: $0) }
    return keys.filter{ $0 != "moreInfo" }
}
