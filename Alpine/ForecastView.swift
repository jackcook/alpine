//
//  ForecastView.swift
//  Alpine
//
//  Created by Jack Cook on 1/23/16.
//  Copyright © 2016 Jack Cook. All rights reserved.
//

import CoreLocation
import MaterialColors
import UIKit

class ForecastView: UIScrollView, UIScrollViewDelegate {
    
    // MARK: Properties
    
    var contentView: ContentView!
    var precipitation: PrecipitationLayer!
    
    private var activityIndicator: UIActivityIndicatorView!
    
    private var coordinate: CLLocationCoordinate2D?
    private var environment: Environment?
    private var landscape: LandscapeLayer!
    private var locationName: String?
    private var requestsDone = 0
    private var requestsTotal = 2
    
    // MARK: Initializers
    
    init() {
        super.init(frame: CGRectZero)
        
        backgroundColor = MaterialColors.BlueGrey.P500.color
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicator.startAnimating()
        addSubview(activityIndicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        activityIndicator.frame = CGRectMake((bounds.width - 32) / 2, (bounds.height - 32) / 2, 32, 32)
        
        guard requestsDone == requestsTotal else {
            return
        }
        
        landscape.frame = bounds
        
        if let _ = precipitation {
            precipitation.frame = bounds
        }
        
        contentView.frame = bounds
    }
    
    // MARK: Public Methods
    
    func setCoordinates(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        
        Forecast.getForecast(coordinate) { (forecast) -> Void in
            var environment = Environment()
            environment.season = Environment.Season(rawValue: forecast.season!)
            environment.precipitationType = forecast.icon! == "rain" ? .Rain : (forecast.icon! == "snow" ? .Snow : .Nothing)
            environment.time = .Day
            
            self.environment = environment
            
            LocationManager.sharedManager.getNameFromCoordinate(coordinate) { (name) -> Void in
                self.locationName = name
                self.renderContentView()
            }
        }
    }
    
    // MARK: Private Methods
    
    private func renderContentView() {
        guard let environment = environment else {
            return
        }
        
        landscape = LandscapeLayer(environment: environment)
        layer.addSublayer(landscape)
        
        let white = environment.hillColor.isEqual(MaterialColors.Cyan.P50.color)
        let color = white ? MaterialColors.BlueGrey.P500.color : UIColor.whiteColor()
        
        contentView = ContentView(color: color)
        contentView.delegate = self
        contentView.locationLabel.text = locationName
        
        addSubview(contentView)
        
        if environment.precipitationType != .None {
            precipitation = PrecipitationLayer()
            precipitation.precipitationType = environment.precipitationType
            contentView.layer.addSublayer(precipitation)
        }
    }
    
    // MARK: UIScrollViewDelegate Methods
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        landscape.adjustForParallax(scrollView.contentOffset.y)
    }
}
