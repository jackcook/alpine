//
//  ContentView.swift
//  Alpine
//
//  Created by Jack Cook on 1/23/16.
//  Copyright © 2016 Jack Cook. All rights reserved.
//

import UIKit

class ContentView: UIScrollView {
    
    // MARK: Properties
    
    private var temperatureLabel: UILabel!
    private var locationLabel: UILabel!
    
    // MARK: Initializers
    
    init() {
        super.init(frame: UIScreen.mainScreen().bounds)
        
        showsVerticalScrollIndicator = false
        
        renderContentView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        temperatureLabel.sizeToFit()
        locationLabel.sizeToFit()
        
        temperatureLabel.frame = CGRectMake((frame.size.width - temperatureLabel.frame.size.width) / 2, (bounds.size.height - temperatureLabel.frame.size.height - locationLabel.frame.size.height - 8) / 2.75, temperatureLabel.frame.size.width, temperatureLabel.frame.size.height)
        
        locationLabel.frame = CGRectMake((frame.size.width - locationLabel.frame.size.width) / 2, temperatureLabel.frame.origin.y + temperatureLabel.frame.size.height + 8, locationLabel.frame.size.width, locationLabel.frame.size.height)
        
        contentSize = CGSizeMake(bounds.width, 2000)
    }
    
    // MARK: Private Methods
    
    private func renderContentView() {
        locationLabel = UILabel()
        locationLabel.font = UIFont.systemFontOfSize(18, weight: UIFontWeightMedium)
        locationLabel.text = "Philadelphia"
        locationLabel.textColor = UIColor.whiteColor()
        addSubview(locationLabel)
        
        temperatureLabel = UILabel()
        temperatureLabel.font = UIFont.systemFontOfSize(96, weight: UIFontWeightRegular)
        temperatureLabel.text = "25°"
        temperatureLabel.textColor = UIColor.whiteColor()
        addSubview(temperatureLabel)
    }
}
