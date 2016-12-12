//
//  DevourVideo.swift
//  Devour
//
//  Created by johnrhickey on 8/17/16.
//  Copyright © 2016 Jay Hickey. All rights reserved.
//

import Foundation

public enum VideoSource : Int {
    case youTube
    case vimeo
    case other
}

public struct DevourVideo: Video {
    let id           : Int
    let date         : Date
    let title        : String
    let summary      : String
    let thumbnailURL : Foundation.URL
    let URL          : Foundation.URL
    let videoID      : String
    let videoSource  : VideoSource
}
