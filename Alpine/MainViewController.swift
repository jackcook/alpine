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
    
    @IBOutlet weak var addButton: UIButton!
    
    private var contentView: ContentView!
    private var statusBarView: UIView!
    private var forecast: Forecast!
    private var landscape: LandscapeLayer!
    private var locationName: String!
    private var precipitation: PrecipitationLayer!
    
    private var coordinate: CLLocationCoordinate2D?
    private var environment: Environment?
    
    private var locationManager: LocationManager!
    private var motionManager: CMMotionManager!
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = MaterialColors.BlueGrey.P500.color
        
        addButton.setImage(addButton.imageForState(.Normal)?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        addButton.tintColor = MaterialColors.DeepOrange.P500.color
        
        LocationManager.sharedManager.startLocationUpdates { (coordinate) -> Void in
            Forecast.getForecast(coordinate, completion: { (forecast) -> Void in
                self.forecast = forecast
                
                var environment = Environment()
                environment.season = Environment.Season(rawValue: forecast.season!)
                environment.precipitationType = forecast.icon! == "rain" ? .Rain : (forecast.icon! == "snow" ? .Snow : .Nothing)
                environment.time = forecast.day! == 1 ? .Day : .Night
                
                self.environment = environment
                
                LocationManager.sharedManager.getNameFromCoordinate(coordinate, completion: { (name) -> Void in
                    self.locationName = name
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.renderWeatherData()
                    })
                })
            })
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let _ = statusBarView {
            statusBarView.frame = CGRectMake(0, 0, view.bounds.width, 20)
        }
        
        if let _ = contentView {
            contentView.contentSize = CGSizeMake(view.bounds.width, view.bounds.height - 20)
            contentView.frame = view.bounds
        }
        
        if let _ = precipitation {
            precipitation.frame = view.bounds
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // MARK: Private Methods
    
    private func renderWeatherData() {
        statusBarView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 20))
        statusBarView.backgroundColor = self.environment?.distantMountainColor
        view.addSubview(statusBarView)
        
        landscape = LandscapeLayer(environment: environment!)
        view.layer.addSublayer(landscape)
        
        view.backgroundColor = environment?.skyColor
        
        let white = environment!.hillColor.isEqual(MaterialColors.Cyan.P50.color)
        let color = white ? MaterialColors.BlueGrey.P50.color : UIColor.whiteColor()
        
        contentView = ContentView(color: color, forecast: forecast)
        contentView.delegate = self
        contentView.locationLabel.text = locationName
        view.addSubview(contentView)
        
        if environment!.precipitationType != .Nothing {
            precipitation = PrecipitationLayer()
            precipitation.precipitationType = environment!.precipitationType
            contentView.layer.addSublayer(precipitation)
            
            motionManager = CMMotionManager()
            
            motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) { (deviceMotion, error) -> Void in
                guard let deviceMotion = deviceMotion else {
                    return
                }
                
                self.precipitation.updateTilt(CGFloat(deviceMotion.attitude.yaw))
            }
        }
    }
    
    // MARK: UIScrollViewDelegate Methods
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        landscape.adjustForParallax(scrollView.contentOffset.y)
    }
}
