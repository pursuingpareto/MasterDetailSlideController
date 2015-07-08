//
//  DetailCell.swift
//  MasterDetailController
//
//  Created by Andy Brown on 7/6/15.
//  Copyright (c) 2015 Andy Brown. All rights reserved.
//

import UIKit



enum DetailCellStyle {
    case Default
}

class DetailCell: UIView {
    var aspectRatio: CGFloat!
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
        titleLabel.frame = CGRect(origin: CGPoint(x: bounds.width * 0.05, y: 0), size: CGSize(width: bounds.width * 0.9, height: bounds.height * 0.1))
        titleLabel.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        titleLabel.font = titleLabel.font.fontWithSize(20)
        addSubview(titleLabel)
        
        var imageFrame = CGRect(origin: CGPoint(x: bounds.width * 0.05, y: bounds.height * 0.12), size: CGSize(width: bounds.width * 0.9, height: bounds.height * 0.8))
        var imageView = UIImageView(frame: imageFrame)
        imageView.contentMode = .ScaleAspectFit
        imageView.image = UIImage()
        centerImageView = imageView
        addSubview(imageView)
        
        descriptionLabel = UILabel()
        descriptionLabel.frame = CGRect(origin: CGPoint(x: bounds.width * 0.05, y: bounds.height * 0.57), size: CGSize(width: bounds.width * 0.9, height: bounds.height * 0.4))
        descriptionLabel.numberOfLines = 7
        descriptionLabel.font = descriptionLabel.font.fontWithSize(10)
        addSubview(descriptionLabel)
        
        self.layer.borderColor = UIColor.blackColor().CGColor
//        self.layer.borderWidth = 1
        self.layer.cornerRadius = 4
        self.backgroundColor = UIColor.whiteColor()
    }
}