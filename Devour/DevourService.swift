//
//  DevourService.swift
//  Devour
//
//  Created by johnrhickey on 8/17/16.
//  Copyright © 2016 Jay Hickey. All rights reserved.
//

import Foundation

typealias DevourResource = (Int, @escaping (Data?, Error?) -> Void) -> Void

// MARK: Public

public func fetchDevourVideos(type: DevourVideoType, page: Int, completion: @escaping ([DevourVideo]) -> Void) {
    let service = DevourAPIService(URLSession: URLSession.shared)
    
    switch type {
    case .Latest:
        fetchDevourVideos(resource: service.latestResource, page: page, completion: completion);
    case .Popular:
        fetchDevourVideos(resource: service.popularResource, page: page, completion: completion);
    }
    
}

// MARK: Private

private func fetchDevourVideos(resource: DevourResource, page: Int, completion: @escaping ([DevourVideo]) -> Void) -> Void {
    resource(page) { data, error in
        if let data = data {
            let devourVideo = devourVideoFromData(data)
            completion(devourVideo)
        } else {
            completion([DevourVideo]())
        }
    }
}

private func devourVideoFromData(_ data: Data) -> [DevourVideo] {
    
    // Attempt to validate and parse JSON from NSData
    let json = JSON(data: data)
    let parser = DevourVideoParser()
    if let videos = parse(json, validator: devourVideoValidator, parser: parser) {
        return videos
    }
    
    return [DevourVideo]()
}
