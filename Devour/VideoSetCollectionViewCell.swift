//
//  VideoSetCollectionViewCell.swift
//  Devour
//
//  Created by johnrhickey on 8/17/16.
//  Copyright © 2016 Jay Hickey. All rights reserved.
//

class VideoSetCollectionViewCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var titleLabel: UILabel!
    
    static let reuseIdentifier = "VideoSetCollectionViewCell"
    
    private var emitter: VideoSetEmitter?
    func configureWithEmitter(emitter:VideoSetEmitter) {
        self.emitter = nil
        collectionView.reloadData()
        
        self.emitter = emitter
        self.titleLabel.text = emitter.title
        
        emitter.onUpdate { videos in
            dispatch_async(dispatch_get_main_queue(), { 
                self.titleLabel.text = emitter.title
                
                let collectionView = self.collectionView
                
                let previousVideoCount = collectionView.numberOfItemsInSection(0)
                if previousVideoCount > videos.count || previousVideoCount == 0 {
                    collectionView.reloadData()
                    return
                }
                
                // Problems occur when scrolling and appending, so don't allow it
                if self.hostViewController.scrolling {
                    collectionView.reloadData()
                    return
                }
                
                collectionView.performBatchUpdates({
                    let paths = (previousVideoCount ..< videos.count).map { NSIndexPath(forRow: $0, inSection: 0) }
                    if paths.count != 0 { self.collectionView.insertItemsAtIndexPaths(paths) }
                    },
                    completion: nil)
            });
        }
    }
    
    func loadImagesForOnScreenRows() {
        _ = self.collectionView.indexPathsForVisibleItems().map({ (indexPath) -> Void in
             guard let cell = self.collectionView.cellForItemAtIndexPath(indexPath) as? VideoCollectionViewCell else { fatalError("Expected to display a `VideoCollectionViewCell`.") }
            cell.loadImage()
        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.emitter = nil;
    }
    
    override var preferredFocusedView: UIView? {
        return collectionView
    }
    
    func collectionView(collectionView: UICollectionView, didUpdateFocusInContext context: UICollectionViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        if let emitter = emitter, indexPath = context.nextFocusedIndexPath where (indexPath.row == self.collectionView.numberOfItemsInSection(0) - 1) {
            emitter.getVideos()
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let emitter = emitter else { return 0 }
        return emitter.numberOfVideos
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(VideoCollectionViewCell.reuseIdentifier, forIndexPath: indexPath)
    }
    
    // MARK: UICollectionViewDelegate
    
    // TODO: This feels icky: replace with signals or something else that's better
    
    @IBOutlet var hostViewController: DevourCollectionViewController!
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let emitter = emitter else { return }
        let video = emitter.videoAtIndexPath(indexPath)
        hostViewController.videoSelected(video)
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? VideoCollectionViewCell else { fatalError("Expected to display a VideoCollectionViewCell") }
        guard let emitter = emitter else { return }
        
        let video = emitter.videoAtIndexPath(indexPath)
        cell.configureWithVideo(video)
        if self.collectionView.dragging == false && self.collectionView.decelerating == false {
            cell.loadImage()
        }
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            self.loadImagesForOnScreenRows()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.loadImagesForOnScreenRows()
    }
    
}
