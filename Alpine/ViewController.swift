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
    
    private var statusBarView: UIView!
    private var mainScrollview: UIScrollView!
    private var forecasts: [ForecastView]!
    
    private var locationManager: LocationManager!
    private var motionManager: CMMotionManager!
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusBarView = UIView(frame: CGRectMake(0, 0, view.bounds.width, 20))
        statusBarView.backgroundColor = MaterialColors.BlueGrey.P500.color
        
        mainScrollview = UIScrollView()
        mainScrollview.bounces = false
        mainScrollview.delegate = self
        mainScrollview.pagingEnabled = true
        mainScrollview.showsHorizontalScrollIndicator = false
        
        view.addSubview(mainScrollview)
        view.addSubview(statusBarView)
        
        forecasts = [ForecastView]()
        
        let forecast = ForecastView()
        forecast.tag = 0
        forecasts.append(forecast)
        mainScrollview.addSubview(forecast)
        
        forecast.setWeatherData(0)
        
        motionManager = CMMotionManager()
        
        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) { (deviceMotion, error) -> Void in
            guard let deviceMotion = deviceMotion else {
                return
            }
            
            for forecast in self.forecasts {
                if let _ = forecast.precipitation {
                    forecast.precipitation.updateTilt(CGFloat(deviceMotion.attitude.yaw))
                }
            }
        }
        
        LocationManager.sharedManager.startLocationUpdates { (name) -> Void in
            forecast.setLocationName(name)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mainScrollview.frame = view.bounds
        mainScrollview.contentSize = CGSizeMake(view.bounds.width * CGFloat(forecasts.count), view.bounds.height)
        
        for forecast in forecasts {
            forecast.frame = CGRectMake(view.bounds.width * CGFloat(forecast.tag), 0, view.bounds.width, view.bounds.height)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // MARK: UIScrollViewDelegate Methods
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageWidth = scrollView.bounds.width
        let page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        
        for forecast in forecasts {
            forecast.contentView.pageControl.currentPage = Int(page)
        }
    }
}
