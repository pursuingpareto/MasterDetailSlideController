//
//  DetailContainer.swift
//  MasterDetailController
//
//  Created by Andy Brown on 7/6/15.
//  Copyright (c) 2015 Andy Brown. All rights reserved.
//

import UIKit

enum ExpansionState {
    case Collapsed
    case Expanded
}

class DetailContainer: UIScrollView {
//    var anchorPoint = CGPoint(x: 0.5, y: 1.0)
    var defaultTransform: CGAffineTransform!
    var zoomView: UIView!
    var expansionState: ExpansionState = .Collapsed
    var maxScale: CGFloat = 1.2
    var minScale: CGFloat = 0.5
    var cellAspectRatio: CGFloat!
    var cellsInContainer: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addZoomView()

        setDefaultTransform()
        maximumZoomScale = 6.0
        minimumZoomScale = 0.5
        delaysContentTouches = true
        multipleTouchEnabled = true
        pagingEnabled = false
        directionalLockEnabled = false
        showsVerticalScrollIndicator = false
        clipsToBounds = false
//        maximumZoomScale = (1 / ( 1 - fractionOfViewOccupiedByTopView)) * maxScale
        clipsToBounds = false
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: -2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.5
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDefaultTransform() {

    }
    
    
    
    func addZoomView() {
        zoomView = UIView()
        zoomView.bounds = bounds
        zoomView.frame.origin = CGPointZero
        zoomView.multipleTouchEnabled = true
        addSubview(zoomView)
    }
    
    func scale(byFactor factor: CGFloat) {
        zoomScale *= factor
    }
    
    func snapToTop() {
        
    }
    
    func scale(toFactor factor: CGFloat) {
        println("factor is \(factor)")
        var animated: Bool
        if (abs(factor - zoomScale) / zoomScale) > 0.1 {
            animated = false
        } else {
            animated = true
        }
        setZoomScale(factor, animated: animated)

        addEdgeInsets()

    }
    func addEdgeInsets() {

        let heightToAdjust = frame.size.height * (zoomScale - 1.0)
        println("heightToAdjust is \(heightToAdjust)")
        let bottomInset = UIEdgeInsetsMake(0, 0, heightToAdjust, 0)
        contentInset = bottomInset
        contentOffset.y = heightToAdjust
    }
    
}
