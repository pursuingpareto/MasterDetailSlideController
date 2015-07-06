//
//  HierarchicalSlidingViewController.swift
//  HierarchicalSlidingViewController
//
//  Created by Andrew Brown on 7/2/15.
//  Copyright (c) 2015 Andrew Brown. All rights reserved.
//

import UIKit
//import Cocoa

class HierarchicalSlidingViewController: UIViewController {
    
    var delegate: HierarchicalSlidingViewControllerDelegate?
    var dataSource: HierarchicalSlidingViewControllerDataSource!
    var hierarchicalSlidingView: HierarchicalSlidingView!
    
    var defaultBottomTransform: CGAffineTransform!
    var currentSection: Int = 0 {
        didSet(oldValue) {
            if oldValue != currentSection {
                self.pageControl.currentPage = currentSection
                self.numRowsInCurrentSection = dataSource.hierarchicalSlidingView(view, numberOfRowsInSection: currentSection)
                setupBottomContainerView()
                loadVisiblePagesFor(scrollView: bottomContainerView)
                
            }
        }
    }
    
    private var fractionOfViewOccupiedByTopView: CGFloat = 6.0 / 11.0
    private var minBottomViewHeight: CGFloat = 100
    var cellAspectRatio: CGFloat!
    var startLocationOfLastPan: CGPoint!
    
    var bottomContainerView: BottomContainerView!
    var zoomView: UIView!
//    var bottomContainerView: BottomContainerView!
    var topContainerView: TopContainerView!
    var bottomViews: [UIView?] = []
    var topViews: [UIView?] = []
    var pageControl: UIPageControl!
    
    var maxScale : CGFloat!
    var minScale: CGFloat!
    var k : CGFloat!
    var logisticX0: CGFloat!
    var numSections: Int!
    var numRowsInCurrentSection: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGrayColor()
        numSections = dataSource.numberOfSectionsInHSView(view)
        numRowsInCurrentSection = dataSource.hierarchicalSlidingView(view, numberOfRowsInSection: currentSection)
        hierarchicalSlidingView = HierarchicalSlidingView(frame: view.frame)
        cellAspectRatio = hierarchicalSlidingView.aspectRatio
        
        maxScale = 1.2 / (1 - fractionOfViewOccupiedByTopView)
        minScale = 0.5
        k = 3.0
        let arg = (maxScale - minScale) / (1.0 - minScale) - 1.0
        logisticX0 = (1.0 / k) * log(arg)
        
        addTopAndBottomContainerViews()
        loadVisiblePagesFor(scrollView: topContainerView)
        loadVisiblePagesFor(scrollView: bottomContainerView)
        
        // math
    }
    
    func setupHSView() {
        hierarchicalSlidingView.frame = self.view.frame
    }
    
    func getIndexOfVisiblePage(view: UIScrollView) -> Int {
        if view is BottomContainerView {
            let pageWidth = bottomContainerView.frame.size.height * cellAspectRatio * bottomContainerView.zoomScale
            let pageIndex = Int(floor((bottomContainerView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
            return pageIndex
        } else {
            let pageWidth = topContainerView.frame.size.width
            let pageIndex = Int(floor((topContainerView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
            return pageIndex
        }
        
    }
    
    func loadVisiblePagesFor(scrollView view: UIScrollView) {
        let page = getIndexOfVisiblePage(view)
        let numPages: Int!
        if view is BottomContainerView {
            numPages = numRowsInCurrentSection
        } else {
            currentSection = getCurrentSectionIndex()
            numPages = numSections
        }
        let firstPage = page - 1
        let lastPage = page + 2
        for var index = 0; index < firstPage; ++index {
            purgePageFor(scrollView: view, atIndex: index)
        }
        for index in firstPage...lastPage {
            
            loadPageFor(scrollView: view, atIndex: index)
        }
        for var index = lastPage+1; index < numPages; ++index {
            purgePageFor(scrollView: view, atIndex: index)
        }
    }
    
    func getCurrentSectionIndex() -> Int {
        let pageWidth = topContainerView.bounds.width
        let section = Int(floor((topContainerView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        return section
    }
    
    func purgePageFor(scrollView view: UIScrollView, atIndex index: Int) {
        if view is TopContainerView {
            if index < 0 || index >= numSections {
                return
            }
            if let topView = topViews[index] {
                topView.removeFromSuperview()
                topViews[index] = nil
            }
        } else if view is BottomContainerView {
            if (index < 0 || index >= numRowsInCurrentSection) {
                return
            }
            if let bottomView = bottomViews[index] {
                bottomView.removeFromSuperview()
                bottomViews[index] = nil
            } 
        }
    }
    
    func loadPageFor(scrollView view: UIScrollView, atIndex index: Int) {
        if view is TopContainerView {
            if index < 0 || index >= numSections {
                return
            }
            if let topView = topViews[index] {
                return
                // do nothing... already loaded
            } else {
                let topView = dataSource.hierarchicalSlidingView(hierarchicalSlidingViewController: self, topViewForSectionAtIndex: index)
                let frameSize = CGSize(width: view.bounds.width, height: view.bounds.height)
                let frameOrigin = CGPoint(x: CGFloat(index) * frameSize.width, y: 0)
                topView.frame = CGRect(origin: frameOrigin, size: frameSize)
                topViews[index] = topView
                topContainerView.addSubview(topView)
            }
        } else if view is BottomContainerView {
            if index < 0 || index >= numRowsInCurrentSection {
                return
            }
            if let bottomView = bottomViews[index] {
                return
            } else {
                let bottomView = dataSource.hierarchicalSlidingView(hierarchicalSlidingViewController: self, collapsedCellForRowAtIndexPath: NSIndexPath(forRow: index, inSection: currentSection))
                let frameSize = CGSize(width: view.bounds.height * cellAspectRatio, height: view.bounds.height)
                let frameOrigin = CGPoint(x: CGFloat(index) * frameSize.width, y: 0)
                bottomView.frame = CGRect(origin: frameOrigin, size: frameSize)
                bottomViews[index] = bottomView
//                bottomContainerView.addSubview(bottomView)
                zoomView.addSubview(bottomView)
            }
        }
    }
    
    func addTopAndBottomContainerViews() {
        let topFrame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height * fractionOfViewOccupiedByTopView)
        topContainerView = TopContainerView(frame: topFrame)
        updateContentSizeFor(topContainerView)
        setupTopContainerView()
        view.addSubview(topContainerView)
        
        addPageControl()
        
        let bottomFrame = CGRectMake(0, topFrame.height, self.view.bounds.width, self.view.bounds.height * (1 - fractionOfViewOccupiedByTopView))
        bottomContainerView = BottomContainerView(frame: bottomFrame)
//        bottomContainerView.frame = bottomFrame
        updateContentSizeFor(bottomContainerView)
        view.addSubview(bottomContainerView)
        
        // TRYING THIS...
        zoomView = UIView()
        zoomView.bounds = bottomContainerView.bounds
        zoomView.frame.origin = CGPointZero
        addPanRecTo(zoomView)
//        addPanRecTo(bottomContainerView)
        
        bottomContainerView.addSubview(zoomView)
        
        
        
        
        defaultBottomTransform = CGAffineTransformMakeTranslation(0, 0.5 * bottomContainerView.layer.frame.height)
        
        bottomContainerView.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        zoomView.layer.anchorPoint = CGPoint(x:0.5, y:1.0)
        
        bottomContainerView.transform = defaultBottomTransform
        zoomView.transform = defaultBottomTransform
        
        setupBottomContainerView()
        view.bringSubviewToFront(bottomContainerView)
    }
    
    func setupTopContainerView() {
        topContainerView.delegate = self
        
        topContainerView.delaysContentTouches = true
        topContainerView.multipleTouchEnabled = true
        topContainerView.directionalLockEnabled = true
        topContainerView.showsVerticalScrollIndicator = false
        topContainerView.showsHorizontalScrollIndicator = false
        
        topContainerView.pagingEnabled = true
        let numSubviews = numSections
        topViews = []
        for _ in 0..<numSubviews {
            topViews.append(nil)
        }
    }
    
    func setupBottomContainerView() {

        let numSubviews = numRowsInCurrentSection
        bottomContainerView.delaysContentTouches = true
        bottomContainerView.delegate = self
//        bottomContainerView.gestureRecognizers.first?.delegate = self
        bottomContainerView.multipleTouchEnabled = true
        bottomContainerView.scalingDelegate = self
        bottomContainerView.pagingEnabled = false
        bottomContainerView.directionalLockEnabled = true
        bottomContainerView.showsVerticalScrollIndicator = false
        bottomContainerView.clipsToBounds = false
        bottomContainerView.maximumZoomScale = (1 / ( 1 - fractionOfViewOccupiedByTopView)) * maxScale
        bottomContainerView.clipsToBounds = false
        bottomContainerView.layer.shadowColor = UIColor.blackColor().CGColor
        bottomContainerView.layer.shadowOffset = CGSize(width: 0, height: -2)
        bottomContainerView.layer.shadowRadius = 4
        bottomContainerView.layer.shadowOpacity = 0.5
        
        updateContentSizeFor(bottomContainerView)
        for v in zoomView.subviews {
            v.removeFromSuperview()
        }
        bottomViews = []
        for _ in 0..<numSubviews {

            bottomViews.append(nil)
        }
        
    }
    
    func addPageControl() {
        let pageControlFrame = CGRectMake(0, 6.2 / 7.0 * topContainerView.bounds.height, view.bounds.width, 40)
        pageControl = UIPageControl(frame: pageControlFrame)
        pageControl.currentPage = currentSection
        pageControl.numberOfPages = dataSource.numberOfSectionsInHSView(view)
        pageControl.tintColor = UIColor.lightGrayColor()
        pageControl.currentPageIndicatorTintColor = UIColor.whiteColor()
        view.addSubview(pageControl)
        view.bringSubviewToFront(pageControl)
    }
    
    func updateContentSizeFor(scrollView: UIScrollView) {
        if scrollView is BottomContainerView {
            scrollView.contentSize.width = scrollView.bounds.height * cellAspectRatio * CGFloat(numRowsInCurrentSection) * scrollView.zoomScale
        } else if scrollView is TopContainerView {
            println(scrollView.contentSize)
            println(dataSource)
            scrollView.contentSize.width = scrollView.bounds.width * CGFloat(numSections)

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func getCell(forTopContainerView view: TopContainerView, withStyle style: TopViewStyle) -> TopView {
        let cell = TopView()
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(origin: CGPoint(x: view.bounds.width * 0.0, y: 0), size: CGSize(width: view.bounds.width, height: view.bounds.height * 0.2))
        
        titleLabel.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        
        var imageFrame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: view.bounds.width, height: view.bounds.height))
        
        
        var imageView = UIImageView(frame: imageFrame)
        imageView.contentMode = .ScaleAspectFit
        imageView.image = UIImage()
        cell.addSubview(imageView)
        cell.bringSubviewToFront(imageView)
        cell.centerImageView = imageView
        
        titleLabel.font = titleLabel.font.fontWithSize(20)
        cell.addSubview(titleLabel)
        cell.titleLabel = titleLabel
        return cell
    }
    
    func getCell(forBottomContainerView view: BottomContainerView, withStyle style: BottomViewStyle) -> CollapsedBottomViewCell {
        let cell = CollapsedBottomViewCell()
        let cellWidth = view.bounds.height * cellAspectRatio
        
        var imageFrame = CGRect(origin: CGPoint(x: cellWidth * 0.05, y: view.bounds.height * 0.12), size: CGSize(width: cellWidth * 0.9, height: cellWidth * 0.8))
        var imageView = UIImageView(frame: imageFrame)
        imageView.clipsToBounds = true
        imageView.contentMode = .ScaleAspectFill
        imageView.image = UIImage()
        cell.addSubview(imageView)
        cell.bringSubviewToFront(imageView)
        cell.centerImageView = imageView
        
        let titleLabel = UILabel()
        
        titleLabel.frame = CGRect(origin: CGPoint(x: cellWidth * 0.05, y: 0.01), size: CGSize(width: cellWidth * 0.9, height: view.bounds.height * 0.1))
        titleLabel.font = titleLabel.font.fontWithSize(12)
        cell.addSubview(titleLabel)
        cell.titleLabel = titleLabel
        
        let descriptionLabel = UILabel()
        descriptionLabel.frame = CGRect(origin: CGPoint(x: cellWidth * 0.05, y: view.bounds.height * 0.57), size: CGSize(width: cellWidth * 0.9, height: view.bounds.height * 0.4))
        descriptionLabel.numberOfLines = 7
        descriptionLabel.font = descriptionLabel.font.fontWithSize(10)
        cell.descriptionLabel = descriptionLabel
        cell.addSubview(descriptionLabel)
//        addPanRecTo(bottomViewCell: cell)
        return cell
    }
    
    func addPanRecTo(zoomView: UIView) {
        let panRec = UIPanGestureRecognizer()
        panRec.delegate = self
        panRec.delaysTouchesBegan = false
        panRec.delaysTouchesEnded = true
        panRec.cancelsTouchesInView = false
        zoomView.multipleTouchEnabled = true
        bottomContainerView.multipleTouchEnabled = true
        panRec.addTarget(self, action: "handlePan:")
        zoomView.addGestureRecognizer(panRec)
    }
    
    func handlePan(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(self.view)
        switch sender.state {
        case .Began:
            startLocationOfLastPan = sender.locationInView(self.view)
            if abs(translation.x) > abs(translation.y) {
                sender.enabled = false
                sender.enabled = true
//                return
            } else {
                bottomContainerView.pagingEnabled = false
            }
        case .Changed:
            var newLoc = sender.locationInView(self.view)
            var dx = newLoc.x - startLocationOfLastPan.x
            var dy = newLoc.y - startLocationOfLastPan.y
            
            if let view = sender.view?.superview as? BottomContainerView {
                scaleViewBasedOnPosition(startLocation: startLocationOfLastPan, currentLocation: newLoc)
//                scaleViewForTranslation(view, translation: translation)
            }
        case .Ended:
//            scaleViewBasedOnVelocity(sender.velocityInView(self.view))

            if bottomViewShouldSnapToPlace() {
                bottomContainerView.pagingEnabled = true
                topContainerView.pagingEnabled = false
                topContainerView.scrollEnabled = false
                snapBottomViewToPlace()
            } else {
                bottomContainerView.pagingEnabled = false
                topContainerView.pagingEnabled = true
                topContainerView.scrollEnabled = true
                bottomContainerView.pagingEnabled = false
                resetBottomView()
            }
            println("ended")
        case .Possible:
            println("possible")
        case .Cancelled:
            sender.enabled = true
            bottomContainerView.pagingEnabled = false
            println("cancelled")
        case .Failed:
            sender.enabled = true
            bottomContainerView.pagingEnabled = false
            println("failed")
        }
//        sender.enabled = true
    }
    
    
    
    func scaleViewBasedOnPosition(startLocation old: CGPoint, currentLocation new: CGPoint) {
        let verticalDistance = new.y - old.y
        let fractionMoved = verticalDistance / (self.bottomContainerView.layer.frame.height - old.y)
        var newScale = minScale + (self.maxScale - minScale) / (1 + exp(-k * (fractionMoved - logisticX0)))
        let maxScale = 1 / ( 1 - self.fractionOfViewOccupiedByTopView)
        if self.bottomContainerView.zoomScale >= maxScale {
            println("new scale is \(newScale)")
            newScale += (maxScale - 1)
            println("now... \(newScale)")
        }
        scaleViewToScale(self.bottomContainerView, scale: newScale)
        
    }
    
    func bottomViewShouldSnapToPlace() -> Bool {
        if bottomContainerView.zoomScale > 1.5 {
            return true
        } else {
            return false
        }
    }
    
    func scaleViewToScale(view: BottomContainerView, scale: CGFloat) {
        view.zoomScale = scale
        view.contentSize.width = (1 - fractionOfViewOccupiedByTopView) * bottomContainerView.bounds.height * cellAspectRatio * CGFloat(numRowsInCurrentSection) * scale
        
    }
    
    func snapBottomViewToPlace() {
        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: nil, animations: {
            let scale = 1 / (1 - self.fractionOfViewOccupiedByTopView)

            self.scaleViewToScale(self.bottomContainerView, scale: scale)
            
            self.setupBottomContainerView()
            self.loadVisiblePagesFor(scrollView: self.bottomContainerView)
            let index = self.getIndexOfVisiblePage(self.bottomContainerView)
            var size = self.bottomViews[index]?.frame.size
            var origin = CGPoint(x: size!.width * CGFloat(index), y: self.bottomContainerView.layer.frame.origin.y)
            let rect = CGRect(origin: origin, size: size!)
            self.bottomContainerView.scrollRectToVisible(rect, animated: false)
            
            
            }, completion: { finished in
                println("Finished")
        })
    }
    
    func resetBottomView() {
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: nil, animations: {
            self.scaleViewToScale(self.bottomContainerView, scale: 1)
            }, completion: { finished in
                self.setupBottomContainerView()
                self.loadVisiblePagesFor(scrollView: self.bottomContainerView)
        })
    }
    
    func scaleViewByFactor(view: BottomContainerView, scaleFactor: CGFloat) {
        view.zoomScale *= scaleFactor
//        view.contentSize.width *= scaleFactor
    }
    
    func scaleViewForTranslation(view: BottomContainerView, translation: CGPoint) {
        let scaleFactor: CGFloat = (1000 - translation.y) / 1000
        scaleViewByFactor(view, scaleFactor: scaleFactor)
    }
}

extension HierarchicalSlidingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        loadVisiblePagesFor(scrollView: scrollView)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        if scrollView is BottomContainerView {
            return self.zoomView
        } else {
            return self.topContainerView
        }
    }

    
}

extension HierarchicalSlidingViewController: ScaleScrollViewDelegate {
    
}

extension HierarchicalSlidingViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.view is TopContainerView {
            return true
        } else {
            return false
        }
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panRec = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panRec.translationInView(view)
            if abs(translation.x) > abs(translation.y) {
                return false
            } else {
                return true
            }
        } else if gestureRecognizer.view is TopContainerView {
            return false
        } else {
            return true
        }
        
    }
}

