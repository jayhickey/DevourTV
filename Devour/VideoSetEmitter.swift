//
//  VideoEmitter.swift
//  Devour
//
//  Created by johnrhickey on 8/17/16.
//  Copyright © 2016 Jay Hickey. All rights reserved.
//

import Foundation

typealias EmitterUpdateCallback = ((_ videos: [Video]) -> ())

protocol VideoSetEmitter {
    var title: String { get }
    var numberOfVideos: Int { get }
    
    func videoAtIndexPath(_ index: IndexPath) -> Video
    func getVideos()
    func onUpdate( _ callback: @escaping EmitterUpdateCallback )
    func reset()
}
