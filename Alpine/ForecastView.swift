//
//  ForecastView.swift
//  Alpine
//
//  Created by Jack Cook on 1/23/16.
//  Copyright © 2016 Jack Cook. All rights reserved.
//

import MaterialColors
import UIKit

class ForecastView: UIScrollView, UIScrollViewDelegate {
    
    // MARK: Properties
    
    var contentView: ContentView!
    var precipitation: PrecipitationLayer!
    
    private var activityIndicator: UIActivityIndicatorView!
    
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
    
    func setLocationName(name: String) {
        locationName = name
        
        requestsDone += 1
        renderContentView()
    }
    
    func setWeatherData(/*forecast: Forecast*/placeholder: Int) {
        var environment = Environment()
        environment.season = .Fall
        environment.precipitationType = .Nothing
        environment.time = .Night
        
        self.environment = environment
        
        requestsDone += 1
        renderContentView()
    }
    
    // MARK: Private Methods
    
    private func renderContentView() {
        guard requestsDone == requestsTotal,
            let environment = environment,
                let name = locationName else {
                    return
        }
        
        landscape = LandscapeLayer(environment: environment)
        layer.addSublayer(landscape)
        
        let white = environment.hillColor.isEqual(MaterialColors.Cyan.P50.color)
        let color = white ? MaterialColors.BlueGrey.P500.color : UIColor.whiteColor()
        
        contentView = ContentView(color: color)
        contentView.delegate = self
        contentView.locationLabel.text = name
        
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
