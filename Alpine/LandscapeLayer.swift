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
    
    private var environment: Environment!
    
    private var distantMountains: CALayer!
    private var nearMountains: CALayer!
    private var hills: CALayer!
    
    private let fullHeight: CGFloat = 2000
    
    init(environment env: Environment) {
        super.init()
        
        environment = env
        
        backgroundColor = environment.skyColor.CGColor
        
        distantMountains = CALayer()
        addSublayer(distantMountains)
        
        renderDistantHills()
        
        nearMountains = CALayer()
        addSublayer(nearMountains)
        
        renderForegroundHills()
        
        hills = CALayer()
        addSublayer(hills)
        
        renderSuperForegroundHills()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    
    func adjustForParallax(offset: CGFloat) {
        let bounds = UIScreen.mainScreen().bounds
        
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        
        distantMountains.frame = CGRectMake(0, -offset / 3, bounds.width, fullHeight)
        nearMountains.frame = CGRectMake(0, -offset / 2, bounds.width, fullHeight)
        hills.frame = CGRectMake(0, -offset / 1, bounds.width, fullHeight)
        
        CATransaction.commit()
    }
    
    // MARK: Private Methods
    
    private func renderDistantHills() {
        let bounds = UIScreen.mainScreen().bounds
        let color = environment.distantMountainColor
        
        let minDistance: CGFloat = 30
        let maxDistance: CGFloat = 45
        
        let baseY: CGFloat = 216
        
        var x: CGFloat = -72 / 2
        while x < bounds.width {
            let mountain = Mountain(background: true, environment: environment)
            mountain.frame = CGRectMake(x, baseY - mountain.bounds.height, mountain.bounds.width, mountain.bounds.height)
            
            let distance = CGFloat(arc4random_uniform(UInt32(maxDistance - minDistance))) + minDistance
            x += mountain.bounds.width * distance / 100
            
            distantMountains.addSublayer(mountain)
        }
        
        let fillLayer = CALayer()
        fillLayer.backgroundColor = color.CGColor
        fillLayer.frame = CGRectMake(0, baseY, bounds.width, fullHeight - baseY)
        distantMountains.addSublayer(fillLayer)
    }
    
    private func renderForegroundHills() {
        let bounds = UIScreen.mainScreen().bounds
        let color = environment.nearMountainColor
        
        let baseY: CGFloat = 464
        let minDistance: CGFloat = 40
        let maxDistance: CGFloat = 60
        
        var x: CGFloat = -144 / 3
        while x < bounds.width {
            let mountain = Mountain(background: false, environment: environment)
            mountain.frame = CGRectMake(x, baseY - mountain.bounds.height, mountain.bounds.width, mountain.bounds.height)
            
            let distance = CGFloat(arc4random_uniform(UInt32(maxDistance - minDistance))) + minDistance
            x += mountain.bounds.width * distance / 100
            
            nearMountains.addSublayer(mountain)
        }
        
        let fillLayer = CALayer()
        fillLayer.backgroundColor = color.CGColor
        fillLayer.frame = CGRectMake(0, baseY, bounds.width, fullHeight - baseY)
        nearMountains.addSublayer(fillLayer)
    }
    
    private func renderSuperForegroundHills() {
        let bounds = UIScreen.mainScreen().bounds
        let color = environment.hillColor
        
        let hill = Hill()
        hill.frame = CGRectMake(0, 500, bounds.width, 100)
        
        let fillLayer = CALayer()
        fillLayer.backgroundColor = color.CGColor
        fillLayer.frame = CGRectMake(0, 600, bounds.width, 2000)
        
        hills.addSublayer(hill)
        hills.addSublayer(fillLayer)
    }
}
