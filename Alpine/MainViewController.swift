//
//  ViewController.swift
//  Alpine
//
//  Created by Jack Cook on 1/22/16.
//  Copyright © 2016 Jack Cook. All rights reserved.
//

import CoreLocation
import CoreMotion
import MaterialColors
import UIKit

class MainViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var statusBarView: UIView!
    
    private var forecasts: [ForecastView]!
    
    private var locationManager: LocationManager!
    private var motionManager: CMMotionManager!
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusBarView.backgroundColor = MaterialColors.BlueGrey.P500.color
        
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        forecasts = [ForecastView]()
        
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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        forecasts = [ForecastView]()
        
        let forecast = ForecastView()
        forecast.tag = 0
        forecasts.append(forecast)
        scrollView.addSubview(forecast)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let storedForecasts = defaults.stringArrayForKey("Forecasts")!
        
        for (idx, storedCoordinate) in storedForecasts.enumerate() {
            let components = storedCoordinate.componentsSeparatedByString(",")
            let coordinate = CLLocationCoordinate2DMake((components[0] as NSString).doubleValue, (components[1] as NSString).doubleValue)
            
            let forecast = ForecastView()
            forecast.tag = idx + 1
            forecast.setCoordinates(coordinate)
            forecasts.append(forecast)
            scrollView.addSubview(forecast)
        }
        
        LocationManager.sharedManager.startLocationUpdates { (coordinate) -> Void in
            forecast.setCoordinates(coordinate)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.contentSize = CGSizeMake(view.bounds.width * CGFloat(forecasts.count), view.bounds.height - 20)
        
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
//            forecast.contentView.pageControl.currentPage = Int(page)
        }
    }
}
