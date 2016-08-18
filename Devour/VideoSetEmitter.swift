//
//  VideoEmitter.swift
//  Devour
//
//  Created by johnrhickey on 8/17/16.
//  Copyright © 2016 Jay Hickey. All rights reserved.
//

import Foundation

typealias EmitterUpdateCallback = ((videos: [DevourVideo]) -> ())

protocol VideoSetEmitter {
    var title: String { get }
    var numberOfVideos: Int { get }
    
    func videoAtIndexPath(index: NSIndexPath) -> DevourVideo
    func getVideos()
    func onUpdate( callback: EmitterUpdateCallback )
}