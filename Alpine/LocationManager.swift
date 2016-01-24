//
//  LocationManager.swift
//  Alpine
//
//  Created by Jack Cook on 1/23/16.
//  Copyright © 2016 Jack Cook. All rights reserved.
//

import AddressBook
import CoreLocation
import SwiftyJSON

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    // MARK: Properties
    
    class var sharedManager: LocationManager {
        struct Static {
            static let instance = LocationManager()
        }
        return Static.instance
    }
    
    var locationName: String?
    
    private var completionBlock: ((name: String) -> Void)?
    private var locationManager: CLLocationManager?
    
    // MARK: Public Methods
    
    func autocompleteSearchTerm(query: String, completion: (results: [City]) -> Void) {
        let apiKey = "AIzaSyCe2vJPRf2sEJGDtlpHqjMfsov-gtYaca0"
        let parameters = ["input": query, "key": apiKey, "types": "(cities)"]
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig)
        
        var url = NSURL(string: "https://maps.googleapis.com/maps/api/place/autocomplete/json")!
        url = NSURLByAppendingQueryParameters(url, queryParameters: parameters)
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            guard let data = data else {
                return
            }
            
            var error: NSError?
            let json = JSON(data: data, error: &error)
            
            var cities = [City]()
            
            if let predictions = json["predictions"].array {
                for prediction in predictions {
                    if let name = prediction["description"].string,
                        let placeId = prediction["place_id"].string {
                            let city = City(name: name, placeId: placeId)
                            cities.append(city)
                    }
                }
            }
            
            completion(results: cities)
        }
        
        task.resume()
    }
    
    func getCoordinatesFromPlace(placeId: String, completion: (coordinate: CLLocationCoordinate2D) -> Void) {
        let apiKey = "AIzaSyCe2vJPRf2sEJGDtlpHqjMfsov-gtYaca0"
        let parameters = ["placeid": placeId, "key": apiKey]
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig)
        
        var url = NSURL(string: "https://maps.googleapis.com/maps/api/place/details/json")!
        url = NSURLByAppendingQueryParameters(url, queryParameters: parameters)
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            guard let data = data else {
                return
            }
            
            var error: NSError?
            let json = JSON(data: data, error: &error)
            
            if let result = json["result"].dictionary {
                if let geometry = result["geometry"]?.dictionary {
                    if let location = geometry["location"]?.dictionary {
                        if let lat = location["lat"]?.double,
                            lng = location["lng"]?.double {
                                let coordinate = CLLocationCoordinate2DMake(lat, lng)
                                completion(coordinate: coordinate)
                        }
                    }
                }
            }
        }
        
        task.resume()
    }
    
    func startLocationUpdates(completion: (name: String) -> Void) {
        completionBlock = completion
        
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
    }
    
    // MARK: Private Methods
    
    private func stringFromQueryParameters(queryParameters: [String: String]) -> String {
        var parts: [String] = []
        for (name, value) in queryParameters {
            let part = NSString(format: "%@=%@",
                name.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!,
                value.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!)
            parts.append(part as String)
        }
        return parts.joinWithSeparator("&")
    }
    
    private func NSURLByAppendingQueryParameters(url: NSURL!, queryParameters: [String: String]) -> NSURL {
        let URLString = NSString(format: "%@?%@", url.absoluteString, stringFromQueryParameters(queryParameters))
        return NSURL(string: URLString as String)!
    }
    
    // MARK: CLLocationManagerDelegate Methods
    
    @objc func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locationName == nil,
            let location = locations.last else {
                return
        }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) -> Void in
            guard let placemark = placemarks?.first else {
                return
            }
            
            if let name = placemark.addressDictionary?[kABPersonAddressCityKey] as? String {
                self.locationName = name
                
                if let block = self.completionBlock {
                    block(name: name)
                }
            }
        }
        
        manager.stopUpdatingLocation()
    }
}
