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
    
    private var environment: Environment!
    
    private var landscape: LandscapeLayer!
    
    // MARK: Initializers
    
    init(environment emt: Environment) {
        super.init(frame: CGRectZero)
        
        environment = emt
        
        landscape = LandscapeLayer(environment: environment)
        layer.addSublayer(landscape)
        
        let white = environment.hillColor.isEqual(MaterialColors.Cyan.P50.color)
        let color = white ? MaterialColors.BlueGrey.P500.color : UIColor.whiteColor()
        
        contentView = ContentView(color: color)
        contentView.delegate = self
        
        addSubview(contentView)
        
        if environment.precipitationType != .None {
            precipitation = PrecipitationLayer()
            precipitation.precipitationType = environment.precipitationType
            contentView.layer.addSublayer(precipitation)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        landscape.frame = bounds
        
        if let _ = precipitation {
            precipitation.frame = bounds
        }
        
        contentView.frame = bounds
    }
    
    // MARK: UIScrollViewDelegate Methods
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        landscape.adjustForParallax(scrollView.contentOffset.y)
    }
}
