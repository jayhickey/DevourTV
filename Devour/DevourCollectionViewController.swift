//
//  FirstViewController.swift
//  Devour
//
//  Created by johnrhickey on 8/17/16.
//  Copyright © 2016 Jay Hickey. All rights reserved.
//

import UIKit
import AVFoundation

class DevourCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private var emitters:[VideoSetEmitter]!
    
    var scrolling = false
    var lastOffset = CGPointZero
    var lastOffsetCapture:NSTimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let latestEmitter = DevourVideoSetEmitter(videoType: .Latest)
        let popularEmitter = DevourVideoSetEmitter(videoType: .Popular)
        
        emitters = [latestEmitter, popularEmitter]
        
        _ = emitters.map { $0.getVideos() }
    }
    
    func videoSelected(video: Video) {
        playVideo(video)
    }
    
    // MARK: Private

    private func playVideo(video: Video) {
        let youtubeVideos = videos(video.videoID)
        guard youtubeVideos.count != 0 else {
            let alertController = UIAlertController(title: "Video Unavailable", message: nil, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        // Prefer HD
        if let HDVideo = youtubeVideos.filter({ $0.quality == VideoQuality.HD }).first {
            self.playVideo(HDVideo.URL)
        } else {
            let alertController = videoQualityAlertController(youtubeVideos.map{ $0.qualityString}, success: { qualityString in
                if let videoURL = youtubeVideos.filter({ $0.qualityString == qualityString }).first?.URL {
                    self.playVideo(videoURL)
                }
                
                }, cancel: {
                    self.dismissViewControllerAnimated(true, completion: nil)
            })
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}

extension DevourCollectionViewController {
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return emitters.count
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(VideoSetCollectionViewCell.reuseIdentifier, forIndexPath: indexPath)
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section != 0  { return CGSizeZero }
        return CGSizeMake(view.bounds.width, 180)
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? VideoSetCollectionViewCell else { fatalError("Expected to display a `VideoSetCollectionViewCell`.") }
        
        let emitter = emitters[indexPath.section]
        cell.configureWithEmitter(emitter)
    }
    
    // Scrolling fix garbage

    func pixelsPerSecondConsideredFast() -> CGFloat {
        return 0.5
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        scrolling = true
        
        let currentOffset = scrollView.contentOffset;
        let currentTime:NSTimeInterval = NSDate.timeIntervalSinceReferenceDate()
        
        let timeDiff = currentTime - Double(lastOffsetCapture)
        if (timeDiff > 0.1) {
            
            let distance = currentOffset.y - lastOffset.y
            let scrollSpeedPX = (distance * 10) / 1000
            let scrollSpeed = abs(scrollSpeedPX)
            
            scrolling = scrollSpeed > pixelsPerSecondConsideredFast()
            lastOffset = currentOffset;
            lastOffsetCapture = currentTime
        }
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrolling = false
    }
    
    // MARK: Focus
    
    override func collectionView(collectionView: UICollectionView, canFocusItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        // We don't want this collectionView's cells to become focused.
        // Instead the `UICollectionView` contained in the cell should become focused.
        
        return false
    }
}


