//
//  BottomView.swift
//  HierarchicalSlidingViewController
//
//  Created by Andrew Brown on 7/2/15.
//  Copyright (c) 2015 Andrew Brown. All rights reserved.
//

import UIKit

class BottomContainerView: UIScrollView {
    var scalingDelegate : ScaleScrollViewDelegate?
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        self.multipleTouchEnabled = true
//        self.delaysContentTouches = true
    }
    required override init(frame: CGRect) {
        super.init(frame: frame)
//        self.multipleTouchEnabled = true
//        self.delaysContentTouches = true
    }
    override func touchesShouldBegin(touches: Set<NSObject>!, withEvent event: UIEvent!, inContentView view: UIView!) -> Bool {
        return false
    }
    override func touchesShouldCancelInContentView(view: UIView!) -> Bool {
        return true
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touchCount = touches.count
        let touch = touches.first as! UITouch
        let tapCount = touch.tapCount

    }
//    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
//        let touch = touches.first as! UITouch
//        let dx = touch.locationInView(self).x - touch.previousLocationInView(self).x
//        let dy = touch.locationInView(self).y - touch.previousLocationInView(self).y
//        let translation = CGPoint(x: dx, y: dy)
//        println("translation is \(translation)")
//        scalingDelegate?.scaleViewForTranslation(self, translation: translation)
////        super.touchesMoved(touches, withEvent: event)
//        
//    }
}

protocol ScaleScrollViewDelegate {
    func scaleViewForTranslation(view: BottomContainerView, translation: CGPoint)
}
