//
//  HierarchicalSlidingView.swift
//  HierarchicalSlidingViewController
//
//  Created by Andrew Brown on 7/2/15.
//  Copyright (c) 2015 Andrew Brown. All rights reserved.
//

import UIKit

class HierarchicalSlidingView: UIView {
    
    var fractionOfViewOccupiedByTopView = 6.0 / 11.0
    var aspectRatio: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        aspectRatio = frame.width / frame.height
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        aspectRatio = frame.width / frame.height
    }
    
    func getCell(forTopContainerView view: TopContainerView, withStyle style: TopViewStyle) -> TopView {
        let cell = TopView()
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(origin: CGPoint(x: view.bounds.width * 0.0, y: 0), size: CGSize(width: view.bounds.width, height: view.bounds.height * 0.2))
        
        titleLabel.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        
        var imageFrame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: view.bounds.width, height: view.bounds.height))
        
        
        var imageView = UIImageView(frame: imageFrame)
        imageView.contentMode = .ScaleAspectFit
        imageView.image = UIImage()
        cell.addSubview(imageView)
        cell.bringSubviewToFront(imageView)
        cell.centerImageView = imageView

        titleLabel.font = titleLabel.font.fontWithSize(20)
        cell.addSubview(titleLabel)
        cell.titleLabel = titleLabel
        println(cell.titleLabel!.frame)
        return cell
    }
    
    func getCell(forBottomContainerView view: BottomContainerView, withStyle style: BottomViewStyle) -> CollapsedBottomViewCell {
        let cell = CollapsedBottomViewCell()
        let cellWidth = view.bounds.height * aspectRatio
        
        var imageFrame = CGRect(origin: CGPoint(x: cellWidth * 0.05, y: view.bounds.height * 0.12), size: CGSize(width: cellWidth * 0.9, height: cellWidth * 0.9))
        var imageView = UIImageView(frame: imageFrame)
        imageView.contentMode = .ScaleToFill
        imageView.image = UIImage()
        cell.addSubview(imageView)
        cell.bringSubviewToFront(imageView)
        cell.centerImageView = imageView
        
        let titleLabel = UILabel()
        
        titleLabel.frame = CGRect(origin: CGPoint(x: cellWidth * 0.05, y: 0), size: CGSize(width: cellWidth * 0.9, height: view.bounds.height * 0.1))
        titleLabel.font = titleLabel.font.fontWithSize(12)
        cell.addSubview(titleLabel)
        cell.titleLabel = titleLabel
        
        let descriptionLabel = UILabel()
        descriptionLabel.frame = CGRect(origin: CGPoint(x: cellWidth * 0.05, y: view.bounds.height * 0.67), size: CGSize(width: cellWidth * 0.9, height: view.bounds.height * 0.2))
        descriptionLabel.numberOfLines = 5
        descriptionLabel.font = descriptionLabel.font.fontWithSize(10)
        cell.descriptionLabel = descriptionLabel
        cell.addSubview(descriptionLabel)
//        addPanRecTo(bottomViewCell: cell)
        return cell
    }
    
    func addPanRecTo(bottomViewCell cell: CollapsedBottomViewCell) {
        let panRec = UIPanGestureRecognizer()
        panRec.delaysTouchesBegan = true
        panRec.delaysTouchesEnded = true
        panRec.cancelsTouchesInView = true
        cell.multipleTouchEnabled = false
        panRec.addTarget(self, action: "handlePan:")
        cell.addGestureRecognizer(panRec)
    }
    
//    func handlePan(sender: UIPanGestureRecognizer) {
//        let translation = sender.translationInView(self)
//        switch sender.state {
//        case .Began:
//            // check if user just wants to scroll left / right
//            if abs(translation.x) > abs(2 * translation.y) {
//                sender.enabled = false
//                sender.enabled = true
//                return
//            } else {
//                bottomScrollView.pagingEnabled = false
//            }
//        case .Changed:
//            if let view = sender.view?.superview as? BottomContainerView {
//                scaleViewForTranslation(view, translation: translation)
//            }
//        case .Ended:
////            bottomScrollView.pagingEnabled = true
////            if bottomViewShouldSnapToPlace() {
////                snapBottomViewToPlace()
////            } else {
////                resetBottomView()
////            }
//            println("ended")
//        case .Possible:
//            println("possible")
//        case .Cancelled:
////            bottomScrollView.pagingEnabled = true
//            println("cancelled")
//        case .Failed:
////            bottomScrollView.pagingEnabled = true
//            println("failed")
////        }
//    }
//    func scaleViewForTranslation(view: BottomContainerView, translation: CGPoint) {
//        let scaleFactor: CGFloat = (1000 - translation.y) / 1000
//        view.transform = CGAffineTransformScale(view.transform, scaleFactor, scaleFactor)
//    }
}
