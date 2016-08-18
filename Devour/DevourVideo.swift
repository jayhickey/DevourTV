//
//  DevourVideo.swift
//  Devour
//
//  Created by johnrhickey on 8/17/16.
//  Copyright © 2016 Jay Hickey. All rights reserved.
//

import Foundation

public enum VideoSource : Int {
    case YouTube
    case Vimeo
    case Other
}

public struct DevourVideo: Video {
    let id           : Int
    let date         : NSDate
    let title        : String
    let summary      : String
    let thumbnailURL : NSURL
    let URL          : NSURL
    let videoID      : String
    let videoSource  : VideoSource
}