//
//  LandscapeLayer.swift
//  Alpine
//
//  Created by Jack Cook on 1/22/16.
//  Copyright © 2016 Jack Cook. All rights reserved.
//

import QuartzCore
import UIKit

class LandscapeLayer: CALayer {
    
    // MARK: Properties
    
    private var skyColor: UIColor? {
        get {
            if let backgroundColor = backgroundColor {
                return UIColor(CGColor: backgroundColor)
            }
            
            return nil
        }
        set(newValue) {
            backgroundColor = newValue!.CGColor
        }
    }
    
    private var distantHills: CALayer!
    private var foregroundHills: CALayer!
    private var superForegroundHills: CALayer!
    
    override init() {
        super.init()
        
        skyColor = UIColor.cyan100()
        
        distantHills = CALayer()
        addSublayer(distantHills)
        
        renderDistantHills()
        
        foregroundHills = CALayer()
        addSublayer(foregroundHills)
        
        renderForegroundHills()
        
        superForegroundHills = CALayer()
        addSublayer(superForegroundHills)
        
        renderSuperForegroundHills()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layer Life Cycle
    
    override func layoutSublayers() {
        super.layoutSublayers()
        
        distantHills.frame = bounds
    }
    
    // MARK: Private Methods
    
    private func renderDistantHills() {
        let bounds = UIScreen.mainScreen().bounds
        let color = UIColor.cyan150()
        
        let baseY: CGFloat = 216
        let minWidth: CGFloat = 72
        let maxWidth: CGFloat = 172
        let minHeight: CGFloat = 96
        let maxHeight: CGFloat = 148
        let minDistance: CGFloat = 30
        let maxDistance: CGFloat = 45
        
        var x: CGFloat = -minWidth / 2
        while x < bounds.width {
            let width = CGFloat(arc4random_uniform(UInt32(maxWidth - minWidth))) + minWidth
            let height = CGFloat(arc4random_uniform(UInt32(maxHeight - minHeight))) + minHeight
            
            let path = UIBezierPath()
            path.moveToPoint(CGPointMake(x, baseY))
            path.addLineToPoint(CGPointMake(x + width, baseY))
            path.addLineToPoint(CGPointMake(x + (width / 2), baseY - height))
            path.closePath()
            
            x += width * (CGFloat(arc4random_uniform(UInt32(maxDistance - minDistance))) + minDistance) / 100
            
            let shape = CAShapeLayer()
            shape.fillColor = color.CGColor
            shape.path = path.CGPath
            
            distantHills.addSublayer(shape)
        }
        
        let fillLayer = CALayer()
        fillLayer.backgroundColor = color.CGColor
        fillLayer.frame = CGRectMake(0, baseY, bounds.width, bounds.height - baseY)
        distantHills.addSublayer(fillLayer)
    }
    
    private func renderForegroundHills() {
        let bounds = UIScreen.mainScreen().bounds
        let color = UIColor.cyan300()
        
        let baseY: CGFloat = 432
        let minWidth: CGFloat = 144
        let maxWidth: CGFloat = 344
        let minHeight: CGFloat = 192
        let maxHeight: CGFloat = 296
        let minDistance: CGFloat = 40
        let maxDistance: CGFloat = 60
        
        var x: CGFloat = -minWidth / 3
        while x < bounds.width {
            let width = CGFloat(arc4random_uniform(UInt32(maxWidth - minWidth))) + minHeight
            let height = CGFloat(arc4random_uniform(UInt32(maxHeight - minHeight))) + minHeight
            
            let path = UIBezierPath()
            path.moveToPoint(CGPointMake(x, baseY))
            path.addLineToPoint(CGPointMake(x + width, baseY))
            path.addLineToPoint(CGPointMake(x + (width / 2), baseY - height))
            path.closePath()
            
            x += width * (CGFloat(arc4random_uniform(UInt32(maxDistance - minDistance))) + minDistance) / 100
            
            let color = UIColor.cyan300()
            
            let shape = CAShapeLayer()
            shape.fillColor = color.CGColor
            shape.path = path.CGPath
            
            foregroundHills.addSublayer(shape)
        }
        
        let fillLayer = CALayer()
        fillLayer.backgroundColor = color.CGColor
        fillLayer.frame = CGRectMake(0, baseY, bounds.width, bounds.height - baseY)
        foregroundHills.addSublayer(fillLayer)
    }
    
    private func renderSuperForegroundHills() {
        let bounds = UIScreen.mainScreen().bounds
        let color = UIColor(white: 1, alpha: 0.9)
        
        let baseY: CGFloat = 462
        let minVariance: CGFloat = 22.5
        let maxVariance: CGFloat = 25
        
        let a = CGFloat(arc4random_uniform(75)) / 50 + 0.5
        let b = CGFloat(arc4random_uniform(75)) / 50 + 0.5
        let c = CGFloat(arc4random_uniform(75)) / 50 + 0.5
        
        let v = CGFloat(arc4random_uniform(UInt32(maxVariance - minVariance))) + minVariance
        
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(0, baseY))
        
        var x: CGFloat = 0
        while x < bounds.width {
            path.addLineToPoint(CGPointMake(x, (getHillCurve(a, b, c, v, x) * 10) + baseY))
            x += 1
        }
        
        path.addLineToPoint(CGPointMake(baseY, bounds.height))
        path.addLineToPoint(CGPointMake(0, bounds.height))
        
        path.closePath()
        
        let shape = CAShapeLayer()
        shape.fillColor = color.CGColor
        shape.path = path.CGPath
        
        superForegroundHills.addSublayer(shape)
    }
    
    func getHillCurve(a: CGFloat, _ b: CGFloat, _ c: CGFloat, _ v: CGFloat, _ x: CGFloat) -> CGFloat {
        return sin(a * x / 25) + sin(b * x / 25) + sin(c * x / 25)
    }
}
