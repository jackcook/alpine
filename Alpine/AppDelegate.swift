//
//  AppDelegate.swift
//  Alpine
//
//  Created by Jack Cook on 1/22/16.
//  Copyright © 2016 Jack Cook. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        let forecasts = defaults.stringArrayForKey("Forecasts")
        if forecasts == nil {
            defaults.setObject([String](), forKey: "Forecasts")
        }
        
        return true
    }
}
