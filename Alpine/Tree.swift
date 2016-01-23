//
//  Tree.swift
//  Alpine
//
//  Created by Jack Cook on 1/23/16.
//  Copyright © 2016 Jack Cook. All rights reserved.
//

import QuartzCore
import UIKit

class Tree: CALayer {
    
    private var stump: CAShapeLayer!
    private var leaves: CAShapeLayer!
    
    private let stumpWidth: CGFloat = 16
    private let minWidth: CGFloat = 36
    private let maxWidth: CGFloat = 72
    private let minHeight: CGFloat = 36
    private let maxHeight: CGFloat = 72
    
    override init() {
        super.init()
        
        stump = CAShapeLayer()
        
        let width = CGFloat(arc4random_uniform(UInt32(maxWidth - minWidth))) + minWidth
        let height = CGFloat(arc4random_uniform(UInt32(maxHeight - minHeight))) + minHeight
        
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(height / 2, (width - stumpWidth) / 2))
        path.addLineToPoint(CGPointMake(height / 2, (width + stumpWidth) / 2))
        path.addLineToPoint(CGPointMake(height, (width + stumpWidth) / 2))
        path.addLineToPoint(CGPointMake(height, (width - stumpWidth) / 2))
        path.closePath()
        
        stump.path = path.CGPath
        stump.fillColor = UIColor.redColor().CGColor
        addSublayer(stump)
        
        leaves = CAShapeLayer()
        
        let leavesPath = UIBezierPath()
        leavesPath.moveToPoint(CGPointMake(0, height * 0.75))
        leavesPath.addLineToPoint(CGPointMake(width / 2, 0))
        leavesPath.addLineToPoint(CGPointMake(width, height * 0.75))
        leavesPath.closePath()
        
        leaves.path = leavesPath.CGPath
        leaves.fillColor = UIColor.yellowColor().CGColor
        addSublayer(leaves)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
