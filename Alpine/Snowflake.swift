//
//  Snowflake.swift
//  Alpine
//
//  Created by Jack Cook on 1/23/16.
//  Copyright © 2016 Jack Cook. All rights reserved.
//

import MaterialColors
import QuartzCore
import UIKit

class Snowflake: Precipitation {
    
    override init() {
        super.init()
        
        let color = MaterialColors.Cyan.P50.color
        
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
