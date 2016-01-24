//
//  Hill.swift
//  Alpine
//
//  Created by Jack Cook on 1/23/16.
//  Copyright © 2016 Jack Cook. All rights reserved.
//

import QuartzCore
import UIKit

class Hill: CAShapeLayer {
    
    // MARK: Properties
    
    private var environment: Environment!
    
    private let minVariance: CGFloat = 22.5
    private let maxVariance: CGFloat = 25
    
    // MARK: Initializers
    
    init(environment env: Environment) {
        super.init()
        
        environment = env
        
        let a = CGFloat(arc4random_uniform(75)) / 50 + 0.5
        let b = CGFloat(arc4random_uniform(75)) / 50 + 0.5
        let c = CGFloat(arc4random_uniform(75)) / 50 + 0.5
        
        let v = CGFloat(arc4random_uniform(UInt32(maxVariance - minVariance))) + minVariance
        
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(0, 160))
        
        var x: CGFloat = 0
        while x < UIScreen.mainScreen().bounds.width {
            path.addLineToPoint(CGPointMake(x, getCurve(a, b, c, v, x) * 10))
            x += 1
        }
        
        path.addLineToPoint(CGPointMake(UIScreen.mainScreen().bounds.width, 160))
        path.closePath()
        
        fillColor = environment.hillColor.CGColor
        self.path = path.CGPath
        
        bounds = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 2000)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private Methods
    
    private func getCurve(a: CGFloat, _ b: CGFloat, _ c: CGFloat, _ v: CGFloat, _ x: CGFloat) -> CGFloat {
        let variance: CGFloat = environment.precipitationType == .Snow ? 25 : 75
        
        return sin(a * x / variance) + sin(b * x / variance) + sin(c * x / variance)
    }
}
