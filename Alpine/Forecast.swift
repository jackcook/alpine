//
//  Forecast.swift
//  Alpine
//
//  Created by Jack Cook on 1/23/16.
//  Copyright © 2016 Jack Cook. All rights reserved.
//

import CoreLocation
import SwiftyJSON

class Forecast {
    
    var temperature: Float
    var precipChance: Float
    var humidity: Int
    
    var day: Environment.Time
    var season: Environment.Season
    
    var sixHourTemperature: [Float]
    var sixHourPrecipitation: [Float]
    var sixDayTemperature: [Float]
    var sixDayPrecipitation: [Float]
    
    var coordinate: CLLocationCoordinate2D
    var icon: String
    var sunrise: NSDate
    var sunset: NSDate
    
    var environment: Environment {
        get {
            var environment = Environment()
            environment.season = season
            environment.precipitationType = icon == "rain" ? .Rain : (icon == "snow" ? .Snow : .Nothing)
            environment.time = day
            
            return environment
        }
    }
    
    init(json: JSON) {
        temperature = json["currentTemp"].float!
        precipChance = json["precipProb"].float!
        humidity = json["humidity"].int!
        
        day = Environment.Time(rawValue: json["day"].int!)!
        season = Environment.Season(rawValue: json["season"].int!)!
        
        sixHourTemperature = [Float]()
        sixHourPrecipitation = [Float]()
        
        let sixHour = json["sixHourForecast"].array!
        for (idx, x) in sixHour.enumerate() {
            if let y = x.array {
                for z in y {
                    if let a = z.float {
                        if idx == 0 {
                            sixHourTemperature.append(a)
                        } else {
                            sixHourPrecipitation.append(a)
                        }
                    }
                }
            }
        }
        
        sixDayTemperature = [Float]()
        sixDayPrecipitation = [Float]()
        
        let sixDay = json["sixDayForecast"].array!
        for (idx, x) in sixDay.enumerate() {
            if let y = x.array {
                for z in y {
                    if let a = z.float {
                        if idx == 0 {
                            sixDayTemperature.append(a)
                        } else {
                            sixDayPrecipitation.append(a)
                        }
                    }
                }
            }
        }
        
        let lat = json["lati"].double!
        let lng = json["long"].double!
        coordinate = CLLocationCoordinate2DMake(lat, lng)
        
        icon = json["currentPrecip"].string!
        
        let sunriseTimestamp = json["sunriseTime"].double!
        sunrise = NSDate(timeIntervalSince1970: sunriseTimestamp)
        
        let sunsetTimestamp = json["sunsetTime"].double!
        sunset = NSDate(timeIntervalSince1970: sunsetTimestamp)
    }
    
    static func getForecast(coordinate: CLLocationCoordinate2D, completion: (forecast: Forecast) -> Void) {
        let url = NSURL(string: "http://45.33.74.150:3000/weather/\(coordinate.latitude)/\(coordinate.longitude)/requestData")!
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            guard let data = data else {
                return
            }
            
            var error: NSError?
            let json = JSON(data: data, error: &error)
            
            let forecast = Forecast(json: json)
            completion(forecast: forecast)
        }
        
        task.resume()
    }
}
