//
//  Video.swift
//  Devour
//
//  Created by johnrhickey on 8/17/16.
//  Copyright © 2016 Jay Hickey. All rights reserved.
//

protocol Video {
    var title        : String { get }
    var summary      : String { get }
    var videoID      : String { get }
    
    var URL          : URL { get }
    var thumbnailURL : URL? { get }
    
    var videoSource  : VideoSource { get }
}
