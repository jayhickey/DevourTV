//
//  DevourService.swift
//  Devour
//
//  Created by johnrhickey on 8/17/16.
//  Copyright © 2016 Jay Hickey. All rights reserved.
//

import Foundation

// MARK: Public

public func fetchDevourVideos(type: DevourVideoType, page: Int, completion: [DevourVideo] -> Void) {
    let service = DevourAPIService(URLSession: NSURLSession.sharedSession())
    
    switch type {
    case .Latest:
        fetchDevourVideos(service.fetchLatestDevourJSON, page: page, completion: completion);
    case .Popular:
        fetchDevourVideos(service.fetchPopularDevourJSON, page: page, completion: completion);
    }
    
}

// MARK: Private

private func fetchDevourVideos(service: ((Int, (NSData?, NSError?) -> Void) -> Void), page: Int, completion: [DevourVideo] -> Void) -> Void {
    service(page) { data, error in
        if let data = data {
            let devourVideo = devourVideoFromData(data)
            completion(devourVideo)
        } else {
            completion([DevourVideo]())
        }
    }
}

private func devourVideoFromData(data: NSData) -> [DevourVideo] {
    
    // Attempt to validate and parse JSON from NSData
    let json = JSON(data: data)
    let parser = DevourVideoParser()
    if let videos = parse(json, validator: devourVideoValidator, parser: parser) {
        // success
        return videos
    }
    
    return [DevourVideo]()
}