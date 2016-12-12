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
    
    @IBOutlet fileprivate var reloadButton : UIButton!
    
    fileprivate var emitters:[VideoSetEmitter]!
    
    var scrolling = false
    var lastOffset = CGPoint.zero
    var lastOffsetCapture:TimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let latestEmitter = DevourVideoSetEmitter(videoType: .Latest)
        let popularEmitter = DevourVideoSetEmitter(videoType: .Popular)
        
        emitters = [latestEmitter, popularEmitter]
        
        _ = emitters.map { $0.getVideos() }
    }
    
    func videoSelected(_ video: Video) {
        playVideo(video)
    }
    
    func reloadData() {
        _ = emitters.map { $0.reset(); $0.getVideos() }
    }
    
    // MARK: Private
    
    @IBAction fileprivate func reload(_ sender: UIButton!) {
        reloadData()
    }

    fileprivate func playVideo(_ video: Video) {
        let youtubeVideos = videos(video.videoID)
        guard youtubeVideos.count != 0 else {
            let alertController = UIAlertController(title: "Video Unavailable", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        // Prefer HD
        if let HDVideo = youtubeVideos.filter({ $0.quality == VideoQuality.hd }).first {
            self.playVideo(HDVideo.URL)
        } else {
            let alertController = videoQualityAlertController(youtubeVideos.map{ $0.qualityString}, success: { qualityString in
                if let videoURL = youtubeVideos.filter({ $0.qualityString == qualityString }).first?.URL {
                    self.playVideo(videoURL)
                }
                
                }, cancel: {
                    self.dismiss(animated: true, completion: nil)
            })
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension DevourCollectionViewController {
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return emitters.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: VideoSetCollectionViewCell.reuseIdentifier, for: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section != 0  { return CGSize.zero }
        return CGSize(width: view.bounds.width, height: 180)
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? VideoSetCollectionViewCell else { fatalError("Expected to display a `VideoSetCollectionViewCell`.") }
        
        let emitter = emitters[indexPath.section]
        cell.configureWithEmitter(emitter)
    }
    
    // Scrolling fix garbage

    func pixelsPerSecondConsideredFast() -> CGFloat {
        return 0.5
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrolling = true
        
        let currentOffset = scrollView.contentOffset;
        let currentTime:TimeInterval = Date.timeIntervalSinceReferenceDate
        
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
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrolling = false
    }
    
    // MARK: Focus
    
    override func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        // We don't want this collectionView's cells to become focused.
        // Instead the `UICollectionView` contained in the cell should become focused.
        
        return false
    }
}


