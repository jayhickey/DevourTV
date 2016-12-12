//
//  UIViewController+VideoExtensions.swift
//  Devour
//
//  Created by johnrhickey on 8/17/16.
//  Copyright © 2016 Jay Hickey. All rights reserved.
//

import UIKit

public extension UIViewController {

    func playVideo(_ url: URL) {
        self.present(VideoViewController(url: url), animated: true, completion: nil)
    }
    
    func videoQualityAlertController(_ options: [String], success: @escaping ((String) -> Void), cancel: @escaping ((Void) -> Void)) -> UIAlertController {
        let alertController = UIAlertController(title: "Choose Quality", message: nil, preferredStyle: .alert)
        
        for option in options {
            let action = UIAlertAction(title: option.capitalized, style: .default, handler: { (action) in
                if let title = action.title {
                    success(title.lowercased())
                }
            })
            alertController.addAction(action)
        }
        
        let action = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) in
            cancel()
        })
        alertController.addAction(action)
        return alertController
    }
    
}
