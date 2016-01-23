//
//  LocationManager.swift
//  Alpine
//
//  Created by Jack Cook on 1/23/16.
//  Copyright © 2016 Jack Cook. All rights reserved.
//

import AddressBook
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    // MARK: Properties
    
    class var sharedManager: LocationManager {
        struct Static {
            static let instance = LocationManager()
        }
        return Static.instance
    }
    
    private var locationManager: CLLocationManager?
    
    // MARK: Public Methods
    
    func startLocationUpdates() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
    }
    
    // MARK: CLLocationManagerDelegate Methods
    
    @objc func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) -> Void in
            guard let placemark = placemarks?.first else {
                return
            }
            
            if let name = placemark.addressDictionary?[kABPersonAddressCityKey] {
                print(name)
            }
        }
        
        manager.stopUpdatingLocation()
    }
}
