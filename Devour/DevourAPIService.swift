//
//  DevourAPIService.swift
//  Devour
//
//  Created by johnrhickey on 8/17/16.
//  Copyright © 2016 Jay Hickey. All rights reserved.
//

import Foundation

class DevourAPIService {
    
    let URLSession: URLSession
    let baseURL = "http://uncrate.com/tv/api"
    
    init(URLSession: URLSession) {
        self.URLSession = URLSession
    }
    
    // MARK: Public
    
    func latestResource(page: Int, completion: @escaping (Data?, Error?) -> Void) {
        let urlPath = "\(baseURL)/latestpage\(page).json"
        fetchURL(urlString: urlPath, completion: completion)
    }
    
    func popularResource(page: Int, completion: @escaping (Data?, Error?) -> Void) {
        let urlPath = "\(baseURL)/popularpage\(page).json"
        fetchURL(urlString: urlPath, completion: completion)
    }
    
    // MARK: Private
    
    fileprivate func fetchURL(urlString: String, completion: @escaping (Data?, Error?) -> ()) {
        if let endpoint = URL(string: urlString) {
            let request = URLRequest(url: endpoint)
            self.URLSession.dataTask(with: request, completionHandler: { (data, response, error) in
                completion(data, error)
                return
            }).resume()
        } else {
            completion(nil, NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: nil))
        }
    }
}
