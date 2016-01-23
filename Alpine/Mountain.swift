//
//  Mountain.swift
//  Alpine
//
//  Created by Jack Cook on 1/23/16.
//  Copyright © 2016 Jack Cook. All rights reserved.
//

import QuartzCore
import UIKit

class Mountain: CAShapeLayer {
    
    // MARK: Properties
    
    private var background = false
    private var environment: Environment!
    
    private var color: UIColor {
        get {
            return background ? environment.distantMountainColor : environment.nearMountainColor
        }
    }
    
    private var minWidth: CGFloat {
        get {
            return background ? 72 : 144
        }
    }
    
    private var maxWidth: CGFloat {
        get {
            return background ? 172 : 344
        }
    }
    
    private var minHeight: CGFloat {
        get {
            return background ? 96 : 192
        }
    }
    
    private var maxHeight: CGFloat {
        get {
            return background ? 148 : 296
        }
    }
    
    // MARK: Initializers
    
    init(background bg: Bool, environment env: Environment) {
        super.init()
        
        background = bg
        environment = env
        
        let width = CGFloat(arc4random_uniform(UInt32(maxWidth - minWidth))) + minWidth
        let height = CGFloat(arc4random_uniform(UInt32(maxHeight - minHeight))) + minHeight
        
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(0, height))
        path.addLineToPoint(CGPointMake(width, height))
        path.addLineToPoint(CGPointMake(width / 2, 0))
        path.closePath()
        
        self.path = path.CGPath
        fillColor = color.CGColor
        
        bounds = CGRectMake(0, 0, width, height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
