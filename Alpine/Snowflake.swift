//
//  Snowflake.swift
//  Alpine
//
//  Created by Jack Cook on 1/23/16.
//  Copyright © 2016 Jack Cook. All rights reserved.
//

import QuartzCore
import UIKit

class Snowflake: CAShapeLayer {
    
    var addedToSuperlayer = false
    
    var px = CGFloat(arc4random_uniform(UInt32(UIScreen.mainScreen().bounds.width)))
    var x: CGFloat {
        get {
            return px
        }
        
        set(newValue) {
            px = newValue
        }
    }
    
    var py: CGFloat = 0
    var y: CGFloat {
        get {
            return py
        }
        
        set(newValue) {
            py = newValue
            frame = CGRectMake(x, y, 4, 4)
        }
    }
    
    override init() {
        super.init()
        
        let bounds = UIScreen.mainScreen().bounds
        let color = UIColor.cyan50()
        
        let width: CGFloat = 4
        let x = CGFloat(arc4random_uniform(UInt32(bounds.width)))
        
        frame = CGRectMake(x, 0, width, width)
        
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
