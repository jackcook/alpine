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
    
    var coordinate: CLLocationCoordinate2D?
    var temperature: Float?
    var sunrise: NSDate?
    var sunset: NSDate?
    var sixDayTemperature: [Float]?
    var sixDayPrecipitation: [Float]?
    var precipChance: Float?
    var humidity: Int?
    var icon: String?
    var sixHourTemperature: [Float]?
    var sixHourPrecipitation: [Float]?
    var day: Int?
    var season: Int?
    
    init(json: JSON) {
        print(json)
        
        let lat = json["lati"].double!
        let lng = json["long"].double!
        coordinate = CLLocationCoordinate2DMake(lat, lng)
        temperature = json["currentTemp"].float
        
        let sunriseTimestamp = json["sunriseTime"].double!
        sunrise = NSDate(timeIntervalSince1970: sunriseTimestamp)
        
        let sunsetTimestamp = json["sunsetTime"].double!
        sunset = NSDate(timeIntervalSince1970: sunsetTimestamp)
        
        sixDayTemperature = [Float]()
        sixDayPrecipitation = [Float]()
        
        let sixDay = json["sixDayForecast"].array!
        for (idx, x) in sixDay.enumerate() {
            if let y = x.array {
                for z in y {
                    if let a = z.float {
                        if idx == 0 {
                            sixDayTemperature?.append(a)
                        } else {
                            sixDayPrecipitation?.append(a)
                        }
                    }
                }
            }
        }
        
        precipChance = json["precipProb"].float
        humidity = json["humidity"].int
        icon = json["currentPrecip"].string
        
        sixHourTemperature = [Float]()
        sixHourPrecipitation = [Float]()
        
        let sixHour = json["sixHourForecast"].array!
        for (idx, x) in sixHour.enumerate() {
            if let y = x.array {
                for z in y {
                    if let a = z.float {
                        if idx == 0 {
                            sixHourTemperature?.append(a)
                        } else {
                            sixHourPrecipitation?.append(a)
                        }
                    }
                }
            }
        }
        
        day = json["day"].int
        season = json["season"].int
    }
    
    static func getForecast(coordinate: CLLocationCoordinate2D, completion: (forecast: Forecast) -> Void) {
        let url = NSURL(string: "http://10.251.71.7:3000/weather/\(coordinate.latitude)/\(coordinate.longitude)/requestData")!
        
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
