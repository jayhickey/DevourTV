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
    
    fileprivate var emitter: VideoSetEmitter?
    func configureWithEmitter(_ emitter:VideoSetEmitter) {
        self.emitter = nil
        collectionView.reloadData()
        
        self.emitter = emitter
        self.titleLabel.text = emitter.title
        
        emitter.onUpdate { videos in
            DispatchQueue.main.async(execute: { 
                self.titleLabel.text = emitter.title
                
                let collectionView = self.collectionView
                
                guard let previousVideoCount = collectionView?.numberOfItems(inSection: 0) else { return }
                
                if previousVideoCount > videos.count ||
                    previousVideoCount == 0 ||
                    self.hostViewController.scrolling == true { // Problems occur when scrolling and appending, so don't allow it{
                    collectionView?.reloadData()
                    return
                }
                
                collectionView?.performBatchUpdates({
                    let paths = (previousVideoCount ..< videos.count).map { IndexPath(row: $0, section: 0) }
                    if paths.count != 0 { self.collectionView.insertItems(at: paths) }
                    },
                    completion: nil)
            });
        }
    }
    
    func loadImagesForOnScreenRows() {
        _ = self.collectionView.indexPathsForVisibleItems.map({ (indexPath) -> Void in
             guard let cell = self.collectionView.cellForItem(at: indexPath) as? VideoCollectionViewCell else { fatalError("Expected to display a `VideoCollectionViewCell`.") }
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
    
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if let emitter = emitter, let indexPath = context.nextFocusedIndexPath, (indexPath.row == self.collectionView.numberOfItems(inSection: 0) - 1) {
            emitter.getVideos()
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let emitter = emitter else { return 0 }
        return emitter.numberOfVideos
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.reuseIdentifier, for: indexPath)
    }
    
    // MARK: UICollectionViewDelegate
    
    // TODO: This feels icky: replace with signals or something else that's better
    
    @IBOutlet var hostViewController: DevourCollectionViewController!
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let emitter = emitter else { return }
        let video = emitter.videoAtIndexPath(indexPath)
        hostViewController.videoSelected(video)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? VideoCollectionViewCell else { fatalError("Expected to display a VideoCollectionViewCell") }
        guard let emitter = emitter else { return }
        
        let video = emitter.videoAtIndexPath(indexPath)
        cell.configureWithVideo(video)
        if self.collectionView.isDragging == false && self.collectionView.isDecelerating == false {
            cell.loadImage()
        }
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            self.loadImagesForOnScreenRows()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.loadImagesForOnScreenRows()
    }
    
}
