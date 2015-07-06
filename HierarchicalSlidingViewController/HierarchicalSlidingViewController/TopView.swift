//
//  TopView.swift
//  HierarchicalSlidingViewController
//
//  Created by Andrew Brown on 7/2/15.
//  Copyright (c) 2015 Andrew Brown. All rights reserved.
//

import UIKit

enum TopViewStyle {
    case Default
}

class TopView: UIView {
    var titleLabel: UILabel?
    var centerImage: UIImage?
    var centerImageView: UIImageView?
    var descriptionLabel: UILabel?
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
