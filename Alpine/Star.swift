//
//  Star.swift
//  Alpine
//
//  Created by Jack Cook on 1/23/16.
//  Copyright © 2016 Jack Cook. All rights reserved.
//

import MaterialColors
import QuartzCore
import UIKit

class Star: CAShapeLayer {
    
    private let minWidth: CGFloat = 3
    private let maxWidth: CGFloat = 6
    
    override init() {
        super.init()
        
        let color = MaterialColors.Blue.P50.color
        
        let width: CGFloat = CGFloat(arc4random_uniform(UInt32(maxWidth - minWidth))) + minWidth
        
        let x = CGFloat(arc4random_uniform(UInt32(UIScreen.mainScreen().bounds.width)))
        let y = CGFloat(arc4random_uniform(200))
        
        frame = CGRectMake(x, y, width, width)
        
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(frame.width / 2, 0))
        path.addLineToPoint(CGPointMake(frame.width, frame.height / 2))
        path.addLineToPoint(CGPointMake(frame.width / 2, frame.height))
        path.addLineToPoint(CGPointMake(0, frame.height / 2))
        path.closePath()
        
        fillColor = color.CGColor
        self.path = path.CGPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
