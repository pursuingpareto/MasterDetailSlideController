//
//  SmallBottomViewCell.swift
//  HierarchicalSlidingViewController
//
//  Created by Andrew Brown on 7/2/15.
//  Copyright (c) 2015 Andrew Brown. All rights reserved.
//

import UIKit

enum BottomViewStyle {
    case Default
}

class CollapsedBottomViewCell: UIView {
    var titleLabel: UILabel?
    var centerImage: UIImage?
    var centerImageView: UIImageView?
    var descriptionLabel: UILabel?
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    required override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    func commonInit() {
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 4
        self.backgroundColor = UIColor.whiteColor()
//        self.layer.shadowColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1).CGColor
//        self.layer.shadowOffset = CGSize(width: 0, height: -2)
//        self.layer.shadowRadius = 4
//        self.layer.shadowOpacity = 0.9
    }
}
