//
//  TopContainerView.swift
//  HierarchicalSlidingViewController
//
//  Created by Andrew Brown on 7/2/15.
//  Copyright (c) 2015 Andrew Brown. All rights reserved.
//

import UIKit

class TopContainerView: UIScrollView {
    var pageViews : [TopView?] = []
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }

}
