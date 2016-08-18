//
//  VideoCollectionViewCell.swift
//  Devour
//
//  Created by johnrhickey on 8/17/16.
//  Copyright © 2016 Jay Hickey. All rights reserved.
//

import Foundation

class VideoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private var title : UILabel!
    @IBOutlet private var subtitle : UILabel!
    @IBOutlet private var imageView : UIImageView!
    
    static let reuseIdentifier = "VideoCollectionViewCell"
    
    var imageDownloadSession : NSURLSessionDataTask?
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
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        if (self.focused) {
            self.imageView.adjustsImageWhenAncestorFocused = true
        } else {
            self.imageView.adjustsImageWhenAncestorFocused = false
        }
    }
    
    func configureWithVideo(video: Video) {
        self.video = video
        self.title.text = video.title
        self.subtitle.text = video.summary
        
        if let cachedImage = ImageCache.sharedInstance.objectForKey(video.videoID) as? UIImage {
            dispatch_async(dispatch_get_main_queue(), {
                self.imageView.image = cachedImage
            });
        }
        else {
            
        }
    }
    
    func loadImage() {
        guard let thumbnailURL = self.video?.thumbnailURL, videoID = self.video?.videoID where self.imageView.image == nil else {
            return
        }
        imageDownloadSession = NSURLSession.sharedSession().dataTaskWithURL(thumbnailURL) {
            (data, response, error) in
            if let data = data, image = UIImage(data: data)?.darkened() {
                ImageCache.sharedInstance.setObject(image, forKey: videoID)
                dispatch_async(dispatch_get_main_queue(), {
                    self.imageView.image = image
                });
            }
        }
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
            return UIImage(CGImage: context.createCGImage(filteredImage, fromRect: filteredImage.extent))
        }
        return self
    }

}
