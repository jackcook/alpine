//
//  ViewController.swift
//  Alpine
//
//  Created by Jack Cook on 1/22/16.
//  Copyright © 2016 Jack Cook. All rights reserved.
//

import CoreMotion
import MaterialColors
import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: Properties
    
    private var landscape: LandscapeLayer!
    private var precipitation: PrecipitationLayer!
    
    private var statusBarView: UIView!
    private var contentView: ContentView!
    
    private var locationManager: LocationManager!
    private var motionManager: CMMotionManager!
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var environment = Environment()
        environment.season = .Fall
        environment.precipitationType = .Rain
        environment.time = .Night
        
        landscape = LandscapeLayer(environment: environment)
        view.layer.addSublayer(landscape)
        
        statusBarView = UIView(frame: CGRectMake(0, 0, view.bounds.width, 20))
        statusBarView.backgroundColor = environment.distantMountainColor
        
        let white = environment.hillColor.isEqual(MaterialColors.Cyan.P50.color)
        let color = white ? MaterialColors.BlueGrey.P500.color : UIColor.whiteColor()
        
        contentView = ContentView(color: color)
        contentView.delegate = self
        
        view.addSubview(contentView)
        view.addSubview(statusBarView)
        
        if environment.precipitationType != .None {
            precipitation = PrecipitationLayer()
            precipitation.precipitationType = environment.precipitationType
            contentView.layer.addSublayer(precipitation)
            
            motionManager = CMMotionManager()
            
            motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) { (deviceMotion, error) -> Void in
                guard let deviceMotion = deviceMotion else {
                    return
                }
                
                self.precipitation.updateTilt(CGFloat(deviceMotion.attitude.yaw))
            }
        }
        
        LocationManager.sharedManager.startLocationUpdates()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        landscape.frame = view.bounds
        
        if let _ = precipitation {
            precipitation.frame = view.bounds
        }
        
        contentView.frame = view.bounds
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // MARK: UIScrollViewDelegate Methods
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        landscape.adjustForParallax(scrollView.contentOffset.y)
    }
}
