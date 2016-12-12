//
//  VideoCollectionViewCell.swift
//  Devour
//
//  Created by johnrhickey on 8/17/16.
//  Copyright © 2016 Jay Hickey. All rights reserved.
//

import Foundation

class VideoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet fileprivate var title : UILabel!
    @IBOutlet fileprivate var subtitle : UILabel!
    @IBOutlet fileprivate var imageView : UIImageView!
    
    static let reuseIdentifier = "VideoCollectionViewCell"
    
    var imageDownloadSession : URLSessionDataTask?
    var video : Video?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if let session = imageDownloadSession {
            session.cancel()
        }
        self.video = nil
        self.title.text = nil
        self.subtitle.text = nil
        self.imageView.image = nil
        self.imageDownloadSession = nil
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if (self.isFocused) {
            self.imageView.adjustsImageWhenAncestorFocused = true
        } else {
            self.imageView.adjustsImageWhenAncestorFocused = false
        }
    }
    
    func configureWithVideo(_ video: Video) {
        self.video = video
        self.title.text = video.title
        self.subtitle.text = video.summary
        
        if let cachedImage = ImageCache.sharedInstance.object(forKey: video.videoID as AnyObject) as? UIImage {
            DispatchQueue.main.async(execute: {
                self.imageView.image = cachedImage
            });
        }
    }
    
    func loadImage() {
        guard let thumbnailURL = self.video?.thumbnailURL, let videoID = self.video?.videoID, self.imageView.image == nil else {
            return
        }
        imageDownloadSession = URLSession.shared.dataTask(with: thumbnailURL, completionHandler: {
            (data, response, error) in
            if let data = data, let image = UIImage(data: data)?.darkened() {
                ImageCache.sharedInstance.setObject(image, forKey: videoID as AnyObject)
                DispatchQueue.main.async(execute: {
                    self.imageView.image = image
                });
            }
        }) 
        imageDownloadSession?.resume()
    }
}

extension UIImage {
    
    func darkened() -> UIImage {
        let context = CIContext(options: nil)
        if let filter = CIFilter(name: "CIExposureAdjust") {
            let beginImage = UIKit.CIImage(image: self)
            filter.setValue(beginImage, forKey: kCIInputImageKey)
            filter.setValue(-1.0, forKey: kCIInputEVKey)
            guard let filteredImage = filter.outputImage else { return self }
            return UIImage(cgImage: context.createCGImage(filteredImage, from: filteredImage.extent)!)
        }
        return self
    }

}
