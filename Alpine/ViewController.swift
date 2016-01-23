//
//  ViewController.swift
//  Alpine
//
//  Created by Jack Cook on 1/22/16.
//  Copyright © 2016 Jack Cook. All rights reserved.
//

import CoreMotion
import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: Properties
    
    private var landscape: LandscapeLayer!
    private var snow: SnowLayer!
    
    private var contentView: UIScrollView!
    private var locationLabel: UILabel!
    private var temperatureLabel: UILabel!
    
    private var motionManager: CMMotionManager!
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        landscape = LandscapeLayer()
        view.layer.addSublayer(landscape)
        
        snow = SnowLayer()
        view.layer.addSublayer(snow)
        
        contentView = UIScrollView()
        contentView.delegate = self
        contentView.showsVerticalScrollIndicator = false
        
        view.addSubview(contentView)
        
        renderContentView()
        
        motionManager = CMMotionManager()
        
        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) { (deviceMotion, error) -> Void in
            guard let deviceMotion = deviceMotion else {
                return
            }
            
            self.snow.updateTilt(CGFloat(deviceMotion.attitude.yaw))
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        landscape.frame = view.bounds
        snow.frame = view.bounds
        
        contentView.frame = view.bounds
        
        locationLabel.sizeToFit()
        locationLabel.frame = CGRectMake((contentView.frame.size.width - locationLabel.frame.size.width) / 2, 36, locationLabel.frame.size.width, locationLabel.frame.size.height)
        
        temperatureLabel.sizeToFit()
        temperatureLabel.frame = CGRectMake((view.bounds.size.width - temperatureLabel.frame.size.width) / 2, (view.bounds.size.height - temperatureLabel.frame.size.height) / 2, temperatureLabel.frame.size.width, temperatureLabel.frame.size.height)
        
        contentView.contentSize = CGSizeMake(view.bounds.width, 2000)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // MARK: Private Methods
    
    private func renderContentView() {
        locationLabel = UILabel()
        locationLabel.font = UIFont.systemFontOfSize(18, weight: UIFontWeightMedium)
        locationLabel.text = "Philadelphia"
        locationLabel.textColor = UIColor.whiteColor()
        contentView.addSubview(locationLabel)
        
        temperatureLabel = UILabel()
        temperatureLabel.font = UIFont.systemFontOfSize(96, weight: UIFontWeightRegular)
        temperatureLabel.text = "25º"
        temperatureLabel.textColor = UIColor.whiteColor()
        contentView.addSubview(temperatureLabel)
    }
    
    // MARK: UIScrollViewDelegate Methods
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        landscape.adjustForParallax(scrollView.contentOffset.y)
    }
}
