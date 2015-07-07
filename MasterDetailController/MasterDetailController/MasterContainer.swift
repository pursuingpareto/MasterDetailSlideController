//
//  MasterContainer.swift
//  MasterDetailController
//
//  Created by Andy Brown on 7/6/15.
//  Copyright (c) 2015 Andy Brown. All rights reserved.
//

import UIKit

class MasterContainer: UIScrollView {
    
    let verticalPositionOfPageControl: CGFloat = 6.2 / 7.0
    let heightOfPageControl: CGFloat = 40.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // MARK: override UIScrollView property defaults
        delaysContentTouches = true
        multipleTouchEnabled = true
        directionalLockEnabled = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        pagingEnabled = true
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
