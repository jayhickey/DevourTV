//
//  UIViewController+VideoExtensions.swift
//  Devour
//
//  Created by johnrhickey on 8/17/16.
//  Copyright © 2016 Jay Hickey. All rights reserved.
//

import UIKit

public extension UIViewController {

    func playVideo(url: NSURL) {
        self.presentViewController(VideoViewController(url: url), animated: true, completion: nil)
    }
    
    func videoQualityAlertController(options: [String], success: (String -> Void), cancel: (Void -> Void)) -> UIAlertController {
        let alertController = UIAlertController(title: "Choose Quality", message: nil, preferredStyle: .Alert)
        
        for option in options {
            let action = UIAlertAction(title: option.capitalizedString, style: .Default, handler: { (action) in
                if let title = action.title {
                    success(title.lowercaseString)
                }
            })
            alertController.addAction(action)
        }
        
        let action = UIAlertAction(title: "Cancel", style: .Destructive, handler: { (action) in
            cancel()
        })
        alertController.addAction(action)
        return alertController
    }
    
}
