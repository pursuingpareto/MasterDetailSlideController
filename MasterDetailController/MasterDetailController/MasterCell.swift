//
//  MasterCell.swift
//  MasterDetailController
//
//  Created by Andy Brown on 7/6/15.
//  Copyright (c) 2015 Andy Brown. All rights reserved.
//

import UIKit

enum MasterCellStyle {
    case Default
}

class MasterCell: UIView {
    var titleLabel: UILabel!
    var centerImage: UIImage!
    var centerImageView: UIImageView!
    var descriptionLabel: UILabel!
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    required override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    func commonInit() {
        titleLabel = UILabel()
        titleLabel.frame = CGRect(origin: CGPoint(x: bounds.width * 0.0, y: 0), size: CGSize(width: bounds.width, height: bounds.height * 0.2))
        titleLabel.font = titleLabel.font.fontWithSize(20)
        titleLabel.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        addSubview(titleLabel)
        
        var imageFrame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: bounds.width, height: bounds.height))
        var imageView = UIImageView(frame: imageFrame)
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        
        imageView.image = UIImage()
        centerImageView = imageView
        addSubview(imageView)
        sendSubviewToBack(imageView)
    }
}