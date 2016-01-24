//
//  ContentView.swift
//  Alpine
//
//  Created by Jack Cook on 1/23/16.
//  Copyright © 2016 Jack Cook. All rights reserved.
//

import MaterialColors
import UIKit

class ContentView: UIScrollView {
    
    // MARK: Properties
    
    private var forecast: Forecast!
    
    var temperatureLabel: UILabel!
    var degreeSymbol: UILabel!
    var locationLabel: UILabel!
    var pageControl: UIPageControl!
    
    var sunriseLabel: UILabel!
    var sunriseValueLabel: UILabel!
    
    var sunsetLabel: UILabel!
    var sunsetValueLabel: UILabel!
    
    var hourlyLabel: UILabel!
    var hourlyContent: UIView!
    
    var dailyLabel: UILabel!
    var dailyContent: UIView!
    
    // MARK: Initializers
    
    init(color: UIColor, forecast: Forecast) {
        super.init(frame: UIScreen.mainScreen().bounds)
        
        self.forecast = forecast
        
        tintColor = color
        
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
        degreeSymbol.sizeToFit()
        locationLabel.sizeToFit()
        sunriseLabel.sizeToFit()
        sunriseValueLabel.sizeToFit()
        sunsetLabel.sizeToFit()
        sunsetValueLabel.sizeToFit()
        hourlyLabel.sizeToFit()
        dailyLabel.sizeToFit()
        
        for view in hourlyContent.subviews where view is ForecastEntryView {
            let t = CGFloat(view.tag)
            
            view.frame = CGRectMake(t < 3 ? 0 : hourlyContent.bounds.width / 2, hourlyContent.bounds.height / 3 * (t < 3 ? t : t - 3), hourlyContent.bounds.width / 2, hourlyContent.bounds.height / 3)
        }
        
        for view in dailyContent.subviews where view is ForecastEntryView {
            let t = CGFloat(view.tag)
            
            view.frame = CGRectMake(t < 3 ? 0 : dailyContent.bounds.width / 2, dailyContent.bounds.height / 3 * (t < 3 ? t : t - 3), dailyContent.bounds.width / 2, dailyContent.bounds.height / 3)
        }
        
        temperatureLabel.frame = CGRectMake((frame.size.width - temperatureLabel.frame.size.width) / 2, (bounds.size.height - temperatureLabel.frame.size.height - locationLabel.frame.size.height - pageControl.frame.size.height - 16) / 2.25, temperatureLabel.frame.size.width, temperatureLabel.frame.size.height)
        
        degreeSymbol.frame = CGRectMake(temperatureLabel.frame.origin.x + temperatureLabel.bounds.width, temperatureLabel.frame.origin.y + 12, degreeSymbol.bounds.width, degreeSymbol.bounds.height)
        
        locationLabel.frame = CGRectMake((frame.size.width - locationLabel.frame.size.width) / 2, temperatureLabel.frame.origin.y + temperatureLabel.frame.size.height, locationLabel.frame.size.width, locationLabel.frame.size.height)
        
        pageControl.frame = CGRectMake((frame.size.width - pageControl.bounds.width) / 2, locationLabel.frame.origin.y + locationLabel.bounds.height + 16, pageControl.bounds.width, pageControl.bounds.width)
        
        sunriseLabel.frame = CGRectMake(32, bounds.height + 32, sunriseLabel.bounds.width, sunriseLabel.bounds.height)
        
        sunriseValueLabel.frame = CGRectMake(bounds.width - sunriseValueLabel.bounds.width - 32, bounds.height + 32, sunriseValueLabel.bounds.width, sunriseValueLabel.bounds.height)
        
        sunsetLabel.frame = CGRectMake(32, sunriseLabel.frame.origin.y + sunriseLabel.bounds.height + 12, sunsetLabel.bounds.width, sunsetLabel.bounds.height)
        
        sunsetValueLabel.frame = CGRectMake(bounds.width - sunsetValueLabel.bounds.width - 32, sunriseValueLabel.frame.origin.y + sunriseValueLabel.bounds.height + 12, sunsetValueLabel.bounds.width, sunsetValueLabel.bounds.height)
        
        hourlyLabel.frame = CGRectMake((bounds.width - hourlyLabel.bounds.width) / 2, sunsetLabel.frame.origin.y + sunsetLabel.bounds.height + 32, hourlyLabel.bounds.width, hourlyLabel.bounds.height)
        
        hourlyContent.frame = CGRectMake(24, hourlyLabel.frame.origin.y + hourlyLabel.bounds.height + 12, bounds.width - 64, (bounds.width - 64) * (96/309))
        
        dailyLabel.frame = CGRectMake((bounds.width - dailyLabel.bounds.width) / 2, hourlyContent.frame.origin.y + hourlyContent.bounds.height + 32, dailyLabel.bounds.width, dailyLabel.bounds.height)
        
        dailyContent.frame = CGRectMake(24, dailyLabel.frame.origin.y + dailyLabel.bounds.height + 12, bounds.width - 64, (bounds.width - 64) * (96/309))
        
        contentSize = CGSizeMake(bounds.width, dailyContent.frame.origin.y + dailyContent.bounds.height + 32)
    }
    
    // MARK: Private Methods
    
    private func renderContentView() {
        locationLabel = UILabel()
        locationLabel.font = UIFont.systemFontOfSize(18, weight: UIFontWeightMedium)
        locationLabel.textColor = UIColor.whiteColor()
        addSubview(locationLabel)
        
        temperatureLabel = UILabel()
        temperatureLabel.font = UIFont.systemFontOfSize(96, weight: UIFontWeightRegular)
        temperatureLabel.text = String(Int(forecast.temperature!))
        temperatureLabel.textColor = UIColor.whiteColor()
        addSubview(temperatureLabel)
        
        degreeSymbol = UILabel()
        degreeSymbol.font = UIFont.systemFontOfSize(48, weight: UIFontWeightRegular)
        degreeSymbol.text = "º"
        degreeSymbol.textColor = UIColor.whiteColor()
        addSubview(degreeSymbol)
        
        pageControl = UIPageControl()
        addSubview(pageControl)
        
        sunriseLabel = UILabel()
        sunriseLabel.font = UIFont.systemFontOfSize(16, weight: UIFontWeightSemibold)
        sunriseLabel.text = "Sunrise"
        sunriseLabel.textColor = tintColor
        addSubview(sunriseLabel)
        
        let sunFormatter = NSDateFormatter()
        sunFormatter.dateFormat = "h:mm a"
        
        sunriseValueLabel = UILabel()
        sunriseValueLabel.font = UIFont.systemFontOfSize(16, weight: UIFontWeightSemibold)
        sunriseValueLabel.text = sunFormatter.stringFromDate(forecast.sunrise!)
        sunriseValueLabel.textColor = tintColor
        addSubview(sunriseValueLabel)
        
        sunsetLabel = UILabel()
        sunsetLabel.font = UIFont.systemFontOfSize(16, weight: UIFontWeightSemibold)
        sunsetLabel.text = "Sunset"
        sunsetLabel.textColor = tintColor
        addSubview(sunsetLabel)
        
        sunsetValueLabel = UILabel()
        sunsetValueLabel.font = UIFont.systemFontOfSize(16, weight: UIFontWeightSemibold)
        sunsetValueLabel.text = sunFormatter.stringFromDate(forecast.sunset!)
        sunsetValueLabel.textColor = tintColor
        addSubview(sunsetValueLabel)
        
        hourlyLabel = UILabel()
        hourlyLabel.font = UIFont.systemFontOfSize(24, weight: UIFontWeightSemibold)
        hourlyLabel.text = "Hourly"
        hourlyLabel.textColor = tintColor
        addSubview(hourlyLabel)
        
        hourlyContent = UIView()
        for i in 0...5 {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "ha"
            
            let date = NSDate(timeIntervalSinceNow: 3600 * (Double(i) + 1))
            
            let entry = ForecastEntryView(icon: "Sun", text: formatter.stringFromDate(date), temperature: Int(forecast.sixHourTemperature![i]), chance: Int(forecast.sixHourPrecipitation![i] * 100), color: tintColor)
            entry.tag = i
            hourlyContent.addSubview(entry)
        }
        addSubview(hourlyContent)
        
        dailyLabel = UILabel()
        dailyLabel.font = UIFont.systemFontOfSize(24, weight: UIFontWeightSemibold)
        dailyLabel.text = "Daily"
        dailyLabel.textColor = tintColor
        addSubview(dailyLabel)
        
        dailyContent = UIView()
        for i in 0...5 {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE"
            
            let date = NSDate(timeIntervalSinceNow: 86400 * (Double(i) + 1))
            
            let entry = ForecastEntryView(icon: "Sun", text: formatter.stringFromDate(date).uppercaseString, temperature: Int(forecast.sixDayTemperature![i]), chance: Int(forecast.sixDayPrecipitation![i] * 100), color: tintColor)
            entry.tag = i
            dailyContent.addSubview(entry)
        }
        addSubview(dailyContent)
    }
}
