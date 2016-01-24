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
        
        view.addSubview(statusBarView)
        
        mainScrollview = UIScrollView()
        mainScrollview.bounces = false
        mainScrollview.delegate = self
        mainScrollview.pagingEnabled = true
        mainScrollview.showsHorizontalScrollIndicator = false
        view.addSubview(mainScrollview)
        
        let length = 2
        
        forecasts = [ForecastView]()
        
        var environment = Environment()
        environment.season = .Fall
        environment.precipitationType = .Nothing
        environment.time = .Night
        
        let forecast = ForecastView(environment: environment)
        forecast.contentView.pageControl.numberOfPages = length
        forecast.tag = 0
        forecasts.append(forecast)
        mainScrollview.addSubview(forecast)
        
        var environment2 = Environment()
        environment2.season = .Winter
        environment2.precipitationType = .Snow
        environment2.time = .Day
        
        let forecast2 = ForecastView(environment: environment2)
        forecast2.contentView.pageControl.numberOfPages = length
        forecast2.tag = 1
        forecasts.append(forecast2)
        mainScrollview.addSubview(forecast2)
        
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
        
        LocationManager.sharedManager.startLocationUpdates()
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
