//
//  MasterDetailController.swift
//  MasterDetailController
//
//  Created by Andy Brown on 7/6/15.
//  Copyright (c) 2015 Andy Brown. All rights reserved.
//

import UIKit

class MasterDetailController: UIViewController {
    // MARK: variables declared on initialization
    var dataSource: MasterDetailDataSource!
    var numberOfSections: Int!
    var currentSection: Int = 0 {
        didSet(oldValue) {
            if oldValue != currentSection {

                pageControl.currentPage = currentSection
                rowsInCurrentSection = dataSource.masterDetailController(numberOfRowsInSection: currentSection)
                setupDetailContainer()
                loadVisiblePagesFor(scrollView: detailContainer)
            }
        }
    }
    var rowsInCurrentSection: Int!
    var startLocationOfLastPan: CGPoint!
    var detailExpansionProgress: CGFloat = 0 {
        willSet(newValue) {
                updateViews(forProgress: newValue)
        }
    }
    
    // MARK: three main views
    var detailContainer: DetailContainer!
    var masterContainer: MasterContainer!
    var pageControl: UIPageControl!
    var detailCells: [DetailCell?]!
    var masterCells: [MasterCell?]!
    
    // MARK: variables with default values
    var fractionOfViewOccupiedByMasterContainer: CGFloat = 6.0 / 11.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGrayColor()
        numberOfSections = dataSource.numberOfSections()
        rowsInCurrentSection = dataSource.masterDetailController(numberOfRowsInSection: currentSection)
        
        createMasterContainer()
        createPageControl()
        createDetailContainer()
        
        setupMasterContainer()
        setupDetailContainer()
        
        loadVisiblePagesFor(scrollView: masterContainer)
        loadVisiblePagesFor(scrollView: detailContainer)
    }
    
    func setupMasterContainer() {
        let numSubViews = numberOfSections
        masterCells = []
        updateContentSizeFor(masterContainer)
        for _ in 0..<numSubViews {
            masterCells.append(nil)
        }
    }
    func setupDetailContainer() {
        let numSubViews = rowsInCurrentSection
        
        for v in detailContainer.zoomView.subviews {
            v.removeFromSuperview()
        }
        
        updateContentSizeFor(detailContainer)
        detailCells = []
        for _ in 0..<numSubViews {
            detailCells.append(nil)
        }
    }
    
    func updateContentSizeFor(scrollView: UIScrollView) {
        if let view = scrollView as? DetailContainer {
            view.contentSize.width = view.bounds.height * view.cellAspectRatio * CGFloat(rowsInCurrentSection) * scrollView.zoomScale
        } else if scrollView is MasterContainer {
            scrollView.contentSize.width = scrollView.bounds.width * CGFloat(numberOfSections)
        }
    }
    
    // MARK: Initialization Helper Methods
    func createMasterContainer() {
        var masterFrame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height * fractionOfViewOccupiedByMasterContainer)
        masterContainer = MasterContainer(frame: masterFrame)
        masterContainer.delegate = self
        view.addSubview(masterContainer)
    }
    
    func createPageControl() {
        let pageControlFrame = CGRectMake(0, masterContainer.verticalPositionOfPageControl * masterContainer.bounds.height, view.bounds.width, masterContainer.heightOfPageControl)
        pageControl = UIPageControl(frame: pageControlFrame)
        pageControl.currentPage = currentSection
        pageControl.numberOfPages = numberOfSections
        pageControl.tintColor = UIColor.lightGrayColor()
        pageControl.currentPageIndicatorTintColor = UIColor.whiteColor()
        view.addSubview(pageControl)
        view.bringSubviewToFront(pageControl)
    }
    
    func createDetailContainer() {
        let frameOriginY = view.bounds.height * fractionOfViewOccupiedByMasterContainer
        let frameHeight = view.bounds.height * (1.0 - fractionOfViewOccupiedByMasterContainer)
        let detailFrame = CGRect(x: 0, y: frameOriginY, width: view.bounds.width, height: frameHeight)
        
        println("\n\ndetailFrame is \(detailFrame)")
        println("fractionOfView is \(fractionOfViewOccupiedByMasterContainer)")
        
        
        detailContainer = DetailContainer(frame: detailFrame)
        detailContainer.cellAspectRatio = view.bounds.width / view.bounds.height

        view.addSubview(detailContainer)
        detailContainer.delegate = self
        view.bringSubviewToFront(detailContainer)
        addPanGestureRecognizerTo(detailContainer)
    }
    
    // MARK: dataSource Helper API
    func getCell(forMasterContainer view: MasterContainer, withStyle style: MasterCellStyle) -> MasterCell {
        return MasterCell(frame: CGRect(origin: CGPointZero, size: masterContainer.bounds.size))
    }
    
    func getCell(forDetailContainer view: DetailContainer, withStyle style: DetailCellStyle) -> DetailCell {
        let cellSize = CGSize(width: detailContainer.bounds.height * detailContainer.cellAspectRatio, height: detailContainer.bounds.height)
        return DetailCell(frame: CGRect(origin: CGPointZero, size: cellSize))
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func addPanGestureRecognizerTo(detailContainer: DetailContainer) {
        let panRec = UIPanGestureRecognizer()
        panRec.delegate = self
        panRec.delaysTouchesBegan = false
        panRec.delaysTouchesEnded = true
        panRec.cancelsTouchesInView = false
        panRec.addTarget(self, action: "handlePan:")
        detailContainer.zoomView.addGestureRecognizer(panRec)
    }
    
    func handlePan(sender: UIPanGestureRecognizer) {
//        println("handling")
        let translation = sender.translationInView(self.view)
        switch sender.state {
        case .Began:
            println("began")
            startLocationOfLastPan = sender.locationInView(self.view)
            if abs(translation.x) > abs(translation.y) {
                sender.enabled = false
                sender.enabled = true
            } else {
                detailContainer.pagingEnabled = false
            }
        case .Changed:
            
            if let view = sender.view?.superview as? DetailContainer {

                var progress = getProgress(forCurrentTouchLocation: sender.locationInView(self.view))
//                println(progress)
                detailExpansionProgress = progress

            }
        case .Ended:
            println("ended")
            // TODO: Implement inertia
            snapDetailContainerToPlace()
        default:
            sender.enabled = true
            detailContainer.pagingEnabled = false
        }
    }
    
    func snapDetailContainerToPlace() {
        var progress: CGFloat!
        if detailExpansionProgress < 0.5 {
            detailContainer.expansionState = .Collapsed
            progress = 0.0
        } else {
            detailContainer.expansionState = .Expanded
            progress = 1.0
        }
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: nil, animations: {
                self.detailExpansionProgress = progress
            }, completion: nil)
    }
    
    func updateViews(forProgress progress: CGFloat) {
        let scaleFactor = getScaleFactor(forProgress: progress)
        detailContainer.scale(toFactor: scaleFactor)
        var alpha: CGFloat!
        if progress < 0.0 {
            alpha = 1.0
        } else if progress > 1.0 {
            alpha = 0.0
        } else {
            alpha = 1.0 - progress
        }
        masterContainer.alpha = alpha
    }
    
    func getProgress(forCurrentTouchLocation location: CGPoint) -> CGFloat {
        let verticalDistance = location.y - startLocationOfLastPan.y
        println("vertical distance is \(verticalDistance)")
        let progress: CGFloat!
        switch detailContainer.expansionState {
        case .Collapsed:
            progress = verticalDistance / (detailContainer.layer.frame.height - startLocationOfLastPan.y)
//            println("collapsed")
        case .Expanded:
            progress = 1.0 - (verticalDistance / detailContainer.bounds.height)
//            println("expanded")
        }
        return progress
    }
    
    func getScaleFactor(forProgress progress: CGFloat) -> CGFloat {
        let maxScale:CGFloat = detailContainer.maxScale / (1.0 - fractionOfViewOccupiedByMasterContainer)
        let minScale:CGFloat = detailContainer.minScale
        let k: CGFloat = 3.0
        let arg:CGFloat = (maxScale - minScale) / (1.0 - minScale) - 1.0
        let logisticX0:CGFloat = (1.0 / k) * log(arg)
        var newScale: CGFloat = minScale + (maxScale - minScale) / (1 + exp(-k * (progress - logisticX0)))
        return newScale
    }
    
    func loadVisiblePagesFor(scrollView view: UIScrollView) {
        let page = getIndexOfVisiblePage(view)
        let numPages: Int!
        if view is DetailContainer {
            numPages = rowsInCurrentSection
        } else {
            currentSection = getCurrentSectionIndex()
            numPages = numberOfSections
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
    
    func getIndexOfVisiblePage(view: UIScrollView) -> Int {
        if view is DetailContainer {
            let pageWidth = detailContainer.frame.size.height * detailContainer.cellAspectRatio * detailContainer.zoomScale
            let pageIndex = Int(floor((detailContainer.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
            return pageIndex
        } else {
            let pageWidth = masterContainer.frame.size.width
            let pageIndex = Int(floor((masterContainer.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
            return pageIndex
        }
    }
    
    func purgePageFor(scrollView view: UIScrollView, atIndex index: Int) {
        if view is MasterContainer {
            if index < 0 || index >= numberOfSections {
                return
            }
            if let topView = masterCells[index] {
                topView.removeFromSuperview()
                masterCells[index] = nil
            }
        } else if view is DetailContainer {
            if (index < 0 || index >= rowsInCurrentSection) {
                return
            }
            if let bottomView = detailCells[index] {
                bottomView.removeFromSuperview()
                detailCells[index] = nil
            }
        }
    }
    
    func loadPageFor(scrollView view: UIScrollView, atIndex index: Int) {
        if view is MasterContainer {

            if index < 0 || index >= numberOfSections {
                return
            }
            if let topView = masterCells[index] {
                return
                // do nothing... already loaded
            } else {
                let topView = dataSource.masterDetailController(masterCellForSection: index)
                let frameSize = CGSize(width: view.bounds.width, height: view.bounds.height)
                let frameOrigin = CGPoint(x: CGFloat(index) * frameSize.width, y: 0)
                topView.frame = CGRect(origin: frameOrigin, size: frameSize)
                masterCells[index] = topView
                masterContainer.addSubview(topView)
            }
        } else if view is DetailContainer {
            
            if index < 0 || index >= rowsInCurrentSection {
                return
            }
            
            if let bottomView = detailCells[index] {
                return
            } else {

                let indexPath = NSIndexPath(forRow: index, inSection: currentSection)
                let bottomView = dataSource.masterDetailController(detailCellForRowAtIndexPath: indexPath)
                let frameSize = CGSize(width: view.bounds.height * detailContainer.cellAspectRatio, height: view.bounds.height)
                let frameOrigin = CGPoint(x: CGFloat(index) * frameSize.width, y: 0)
                bottomView.frame = CGRect(origin: frameOrigin, size: frameSize)
                detailCells[index] = bottomView
                detailContainer.zoomView.addSubview(bottomView)
            }
        }
    }
    
    func getCurrentSectionIndex() -> Int {
        let pageWidth = masterContainer.bounds.width
        let section = Int(floor((masterContainer.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        return section
    }

}
extension MasterDetailController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        loadVisiblePagesFor(scrollView: scrollView)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        if scrollView is DetailContainer {
            return detailContainer.zoomView
        } else {
            return masterContainer
        }
    }
}

extension MasterDetailController: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.view is MasterContainer {
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
        } else if gestureRecognizer.view is MasterContainer {
            return false
        } else {
            return true
        }
        
    }

}
