//
//  DevourAPIService.swift
//  Devour
//
//  Created by johnrhickey on 8/17/16.
//  Copyright © 2016 Jay Hickey. All rights reserved.
//

import Foundation

class DevourAPIService {
    
    let URLSession: NSURLSession
    let baseURL = "http://uncrate.com/tv/api"
    
    init(URLSession: NSURLSession) {
        self.URLSession = URLSession
    }
    
    // MARK: Public
    
    func fetchLatestDevourJSON(page: Int, completion: (NSData?, NSError?) -> Void) {
        let urlPath = "\(baseURL)/latestpage\(page).json"
        fetchURL(urlPath, completion: completion)
    }
    
    func fetchPopularDevourJSON(page: Int, completion: (NSData?, NSError?) -> Void) {
        let urlPath = "\(baseURL)/popularpage\(page).json"
        fetchURL(urlPath, completion: completion)
    }
    
    // MARK: Private
    
    private func fetchURL(urlString: String, completion: (NSData?, NSError?) -> Void) {
        if let endpoint = NSURL(string: urlString) {
            let request = NSURLRequest(URL:endpoint)
            self.URLSession.dataTaskWithRequest(request) { (data, response, error) -> Void in
                completion(data, error)
                }.resume()
        } else {
            completion(nil, NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: nil))
        }
    }
    


}