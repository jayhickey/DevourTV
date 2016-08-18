//
//  DevourVideoParsing.swift
//  Devour
//
//  Created by johnrhickey on 8/17/16.
//  Copyright © 2016 Jay Hickey. All rights reserved.
//

import Foundation

// JSON Validation and Parsing for `DevourVideo` struct

let devourVideoValidator = JSONValidator<[DevourVideo]> { (json) -> Bool in
    // validate the json
    do {
        let jsonSerialized = try NSJSONSerialization.JSONObjectWithData(json.data, options: []) as! NSDictionary
        
        guard let results = jsonSerialized["posts"] as? [AnyObject] else {
            return false
        }
        
        // Check to make sure these keys are valid in the JSON response dict
        let validKeys = ["id", "authored_on", "title", "summary", "thumbnail", "url", "video_id", "video_source"]
        let urlKeys = ["thumbnail", "url"]
        let dateKeys = ["authored_on"]
        for result in results {
            for key in validKeys {
                // Check that the key exists and if it needs to be converted to an Int, make sure it's possible to do
                if (result[key] == nil) {
                    return false
                }
            }
            
            for key in urlKeys {
                guard let result = result[key] as? String where NSURL(string: result) != nil else {
                    return false
                }
            }
            
            for key in dateKeys {
                guard let result = result[key] as? String where formatDate(result) != nil else {
                    return false
                }
            }
            
        }
        return true
    }
    catch {
        return false
    }
}


struct DevourVideoParser: JSONParserType {
    
    func parseJSON(jsonData: JSON) -> [DevourVideo] {
        
        var devourVideos = [DevourVideo]()
        
        // Parse the json
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(jsonData.data, options: []) as! NSDictionary
            
            if let results = json["posts"] as? [AnyObject] {
                for result in results {
                    // We can force unwrap since we already did validation
                    let id = result["id"] as! Int
                    let authored_on = formatDate(result["authored_on"] as! String)!
                    let title = result["title"] as! String
                    let summary = result["summary"] as! String
                    let thumbnail = NSURL(string: result["thumbnail"] as! String)!
                    let url = NSURL(string: result["url"] as! String)!
                    let video_id = result["video_id"] as! String
                    let video_source = result["video_source"] as! String
                    
                    var videoSource: VideoSource
                    
                    switch video_source {
                    case "youtube":
                        videoSource = .YouTube
                    case "vimeo":
                        videoSource = .Vimeo
                    default:
                        videoSource = .Other
                    }
                    
                    let devourVideo = DevourVideo(id: id, date: authored_on, title: title, summary: summary, thumbnailURL: thumbnail, URL: url, videoID: video_id, videoSource: videoSource)
                    
                    devourVideos.append(devourVideo)
                }
            }
            return devourVideos
        }
        catch {
            return devourVideos
        }
        
    }
}

private func formatDate(dateString: String) -> NSDate? {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat =  "yyyy-MM-dd'T'HH:mm:ssZ"
    if let date = dateFormatter.dateFromString(dateString) {
        return date
    }
    return nil
}