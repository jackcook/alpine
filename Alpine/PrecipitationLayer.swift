//
//  SnowLayer.swift
//  Alpine
//
//  Created by Jack Cook on 1/23/16.
//  Copyright © 2016 Jack Cook. All rights reserved.
//

import QuartzCore
import UIKit

class PrecipitationLayer: CALayer {
    
    // MARK: Properties
    
    var precipitationType: PrecipitationType!
    
    private var precipitations: [Precipitation]!
    private var addTimer: NSTimer!
    private var updateTimer: NSTimer!
    
    private var currentYaw: CGFloat!
    
    // MARK: Initializers
    
    override init() {
        super.init()
        
        precipitations = [Precipitation]()
        
        addTimer = NSTimer(timeInterval: 0.1, target: self, selector: "addPrecipitation", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(addTimer, forMode: NSRunLoopCommonModes)
        
        updateTimer = NSTimer(timeInterval: 0.0166, target: self, selector: "updatePrecipitations", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(updateTimer, forMode: NSRunLoopCommonModes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    
    func updateTilt(yaw: CGFloat) {
        currentYaw = yaw
    }
    
    // MARK: Private Methods
    
    internal func addPrecipitation() {
        var precipitation: Precipitation?
        
        if precipitationType == PrecipitationType.Snow {
            precipitation = Snowflake()
        } else if precipitationType == PrecipitationType.Rain {
            precipitation = Raindrop()
        }
        
        guard let precip = precipitation else {
            return
        }
        
        precipitations.append(precip)
    }
    
    internal func updatePrecipitations() {
        guard let yaw = currentYaw else {
            return
        }
        
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        
        var i = 0
        for precipitation in precipitations {
            let precip = precipitation
            
            let ax = -sin(yaw)
            let ay = cos(yaw)
            
            precip.x += ax
            precip.y += ay
            
            if !precip.addedToSuperlayer {
                precip.addedToSuperlayer = true
                self.addSublayer(precip)
            }
            
            if !CGRectContainsPoint(UIScreen.mainScreen().bounds, precipitation.frame.origin) {
                precipitation.removeFromSuperlayer()
                precipitations.removeAtIndex(i)
                
                i -= 1
            }
            
            i += 1
        }
        
        CATransaction.commit()
    }
}
