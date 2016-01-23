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
    
    // MARK: Properties
    
    private var mountain: Mountain!
    
    private var leaves: CAShapeLayer!
    
    private let minWidth: CGFloat = 10
    private let maxWidth: CGFloat = 16
    
    // MARK: Initializers
    
    init(mountain mtn: Mountain) {
        super.init()
        
        mountain = mtn
        
        let width = CGFloat(arc4random_uniform(UInt32(maxWidth - minWidth))) + minWidth
        let height = (20/9) * width
        
        leaves = CAShapeLayer()
        
        let leavesPath = UIBezierPath()
        leavesPath.moveToPoint(CGPointMake(0, height))
        leavesPath.addLineToPoint(CGPointMake(width / 2, 0))
        leavesPath.addLineToPoint(CGPointMake(width, height))
        leavesPath.closePath()
        
        leaves.path = leavesPath.CGPath
        leaves.fillColor = mountain.environment.nearMountainColor.CGColor
        addSublayer(leaves)
        
        bounds = CGRectMake(0, 0, width, height)
        
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private Methods
    
    private func setupFrame() {
        var inside = false
        var point = CGPointMake(0, 0)
        
        while !inside {
            point = CGPointMake(CGFloat(arc4random_uniform(UInt32(mountain.bounds.width))), CGFloat(arc4random_uniform(UInt32(mountain.bounds.height))))
            inside = UIBezierPath(CGPath: mountain.path!).containsPoint(point) && UIBezierPath(CGPath: mountain.path!).containsPoint(CGPointMake(point.x + bounds.width, point.y)) && !UIBezierPath(CGPath: mountain.path!).containsPoint(CGPointMake(point.x + (bounds.width / 2), point.y - bounds.height))
        }
        
        frame = CGRectMake(point.x, point.y - bounds.height, bounds.width, bounds.height)
    }
}
