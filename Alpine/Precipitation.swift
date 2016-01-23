//
//  Precipitation.swift
//  Alpine
//
//  Created by Jack Cook on 1/23/16.
//  Copyright © 2016 Jack Cook. All rights reserved.
//

import UIKit

class Precipitation: CAShapeLayer {
    
    var addedToSuperlayer = false
    var fallSpeed: CGFloat = 1.0
    
    var px = CGFloat(arc4random_uniform(UInt32(UIScreen.mainScreen().bounds.width)))
    var x: CGFloat {
        get {
            return px
        }
        
        set(newValue) {
            let ax = (newValue - px) * fallSpeed
            frame = CGRectMake(x, px + ax, 4, 4)
            
            px += ax
        }
    }
    
    var py: CGFloat = 0
    var y: CGFloat {
        get {
            return py
        }
        
        set(newValue) {
            let ay = (newValue - py) * fallSpeed
            frame = CGRectMake(x, py + ay, 4, 4)
            
            py += ay
        }
    }
}
