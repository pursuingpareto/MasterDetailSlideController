//
//  HierarchicalSlidingViewControllerDataSource.swift
//  HierarchicalSlidingViewController
//
//  Created by Andrew Brown on 7/2/15.
//  Copyright (c) 2015 Andrew Brown. All rights reserved.
//

import UIKit

protocol HierarchicalSlidingViewControllerDataSource {
    func numberOfSectionsInHSView(view: UIView) -> Int
    
    func hierarchicalSlidingView(view: UIView,
        numberOfRowsInSection section: Int) -> Int
    
    func hierarchicalSlidingView(hierarchicalSlidingViewController controller: HierarchicalSlidingViewController,
        topViewForSectionAtIndex index: Int) -> TopView
    
    func hierarchicalSlidingView(hierarchicalSlidingViewController controller: HierarchicalSlidingViewController,
        collapsedCellForRowAtIndexPath indexPath: NSIndexPath) -> CollapsedBottomViewCell
    
//    func hierarchicalSlidingView(view: UIView,
//        expandedCellForRowAtIndexPath indexPath: NSIndexPath) -> ExpandedBottomViewCell
    
}