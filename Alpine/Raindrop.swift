//
//  Raindrop.swift
//  Alpine
//
//  Created by Jack Cook on 1/23/16.
//  Copyright © 2016 Jack Cook. All rights reserved.
//

import MaterialColors
import QuartzCore
import UIKit

class Raindrop: Precipitation {
    
    override init() {
        super.init()
        
        let color = MaterialColors.Indigo.P500.color
        
        let width: CGFloat = 4
        let x = CGFloat(arc4random_uniform(UInt32(bounds.width)))
        
        frame = CGRectMake(x, 0, width, width)
        
        let path = UIBezierPath(ovalInRect: frame)
        
        fillColor = color.CGColor
        self.path = path.CGPath
        
        fallSpeed = 5.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
