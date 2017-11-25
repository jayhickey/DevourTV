//
//  DevourVideo.swift
//  Devour
//
//  Created by johnrhickey on 8/17/16.
//  Copyright © 2016 Jay Hickey. All rights reserved.
//

import Foundation

enum VideoSource : String, Codable {
    case youtube
    case vimeo
    case other
}

struct DevourVideo: Video, Codable {
    let id           : Int
    let date         : Date
    let title        : String
    let summary      : String
    let thumbnailURL : URL?
    let URL          : URL
    let videoID      : String
    let videoSource  : VideoSource
    
    enum CodingKeys: String, CodingKey {
        case id
        case date = "authored_on"
        case title
        case summary
        case thumbnailURL = "thumbnail"
        case URL = "url"
        case videoID = "video_id"
        case videoSource = "video_source"
    }
}
