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
    private var precipitation: PrecipitationLayer!
    
    private var coordinate: CLLocationCoordinate2D?
    private var environment: Environment?
    
    private var locationManager: LocationManager!
    private var motionManager: CMMotionManager!
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.setImage(addButton.imageForState(.Normal)?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        addButton.tintColor = MaterialColors.DeepOrange.P500.color
        
        motionManager = CMMotionManager()
        
        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) { (deviceMotion, error) -> Void in
            guard let deviceMotion = deviceMotion else {
                return
            }
            
            self.precipitation.updateTilt(CGFloat(deviceMotion.attitude.yaw))
        }
        
        LocationManager.sharedManager.startLocationUpdates { (coordinate) -> Void in
            Forecast.getForecast(coordinate, completion: { (forecast) -> Void in
                self.forecast = forecast
                
                var environment = Environment()
                environment.season = Environment.Season(rawValue: forecast.season!)
                environment.precipitationType = forecast.icon! == "rain" ? .Rain : (forecast.icon! == "snow" ? .Snow : .Nothing)
                environment.time = forecast.day! == 1 ? .Day : .Night
                
                self.environment = environment
                
                LocationManager.sharedManager.getNameFromCoordinate(coordinate, completion: { (name) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.statusBarView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 20))
                        self.statusBarView.backgroundColor = self.environment?.distantMountainColor
                        self.view.addSubview(self.statusBarView)
                        
                        self.landscape = LandscapeLayer(environment: environment)
                        self.view.layer.addSublayer(self.landscape)
                        
                        self.view.backgroundColor = self.environment?.skyColor
                        
                        let white = environment.hillColor.isEqual(MaterialColors.Cyan.P50.color)
                        let color = white ? MaterialColors.BlueGrey.P50.color : UIColor.whiteColor()
                        
                        self.contentView = ContentView(color: color, forecast: self.forecast)
                        self.contentView.delegate = self
                        self.contentView.locationLabel.text = name
                        self.view.addSubview(self.contentView)
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
    
    // MARK: UIScrollViewDelegate Methods
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        landscape.adjustForParallax(scrollView.contentOffset.y)
    }
}
