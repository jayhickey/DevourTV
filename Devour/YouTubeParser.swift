//
//  YouTubeParser.swift
//  Devour
//
//  Created by johnrhickey on 8/17/16.
//  Copyright © 2016 Jay Hickey. All rights reserved.
//

import Foundation

public enum VideoQuality: Int {
    case HD = 0
    case SD
}

public struct YouTubeVideo {
    let URL           : NSURL
    let quality       : VideoQuality
    let qualityString : String
}

public func videos(id: String) -> [YouTubeVideo] {
    var videos = [YouTubeVideo]()
    
    let videosDict = HCYoutubeParser.h264videosWithYoutubeID(id)
    for key in qualityKeys(id) {
        if let urlString = videosDict[key] as? String, videoURL = NSURL(string: urlString) {
            let video = YouTubeVideo(URL: videoURL, quality: (key == "hd720") ? .HD : .SD, qualityString: key)
            videos.append(video)
        }
    }
    return videos
}

// MARK: Private

private func qualityKeys(id: String) -> [String] {
    let videos = HCYoutubeParser.h264videosWithYoutubeID(id)
    guard videos != nil else {
        return [String]()
    }
    
    let keys = Array(videos.keys).map{ String($0) }
    return keys.filter{ $0 != "moreInfo" }
}