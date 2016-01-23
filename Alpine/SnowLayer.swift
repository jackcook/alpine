//
//  SnowLayer.swift
//  Alpine
//
//  Created by Jack Cook on 1/23/16.
//  Copyright © 2016 Jack Cook. All rights reserved.
//

import QuartzCore
import UIKit

class SnowLayer: CALayer {
    
    // MARK: Properties
    
    private var snowflakes: [CALayer]!
    private var addSnowflakeTimer: NSTimer!
    private var updateSnowflakeTimer: NSTimer!
    
    private var currentYaw: CGFloat!
    
    // MARK: Initializers
    
    override init() {
        super.init()
        
        snowflakes = [CALayer]()
        
        addSnowflakeTimer = NSTimer(timeInterval: 0.1, target: self, selector: "addSnowflake", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(addSnowflakeTimer, forMode: NSRunLoopCommonModes)
        
        updateSnowflakeTimer = NSTimer(timeInterval: 0.0166, target: self, selector: "updateSnowflakes", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(updateSnowflakeTimer, forMode: NSRunLoopCommonModes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    
    func updateTilt(yaw: CGFloat) {
        currentYaw = yaw
    }
    
    // MARK: Private Methods
    
    internal func addSnowflake() {
        let snowflake = Snowflake()
        snowflakes.append(snowflake)
    }
    
    internal func updateSnowflakes() {
        guard let yaw = currentYaw else {
            return
        }
        
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        
        var i = 0
        for snowflake in snowflakes {
            let flake = snowflake as! Snowflake
            
            let ax = -sin(yaw)
            let ay = cos(yaw)
            
            flake.x += ax
            flake.y += ay
            
            if !flake.addedToSuperlayer {
                flake.addedToSuperlayer = true
                self.addSublayer(flake)
            }
            
            if !CGRectContainsPoint(UIScreen.mainScreen().bounds, snowflake.frame.origin) {
                snowflake.removeFromSuperlayer()
                snowflakes.removeAtIndex(i)
                
                i -= 1
            }
            
            i += 1
        }
        
        CATransaction.commit()
    }
}
