//
//  Environment.swift
//  Alpine
//
//  Created by Jack Cook on 1/23/16.
//  Copyright © 2016 Jack Cook. All rights reserved.
//

import UIKit

struct Environment {
    
    var time: Time!
    
    enum Time {
        case Day
        case Dusk
        case Night
    }
    
    var season: Season?
    
    enum Season {
        case Spring
        case Summer
        case Fall
        case Winter
    }
    
    var skyColor: UIColor {
        get {
            switch season! {
            case .Spring:
                return UIColor.cyan100()
            case .Summer:
                return UIColor.orange100()
            case .Fall:
                return UIColor.cyan100()
            case .Winter:
                return UIColor.cyan50()
            }
        }
    }
    
    var distantMountainColor: UIColor {
        get {
            switch season! {
            case .Spring:
                return UIColor.green150()
            case .Summer:
                return UIColor.orange150()
            case .Fall:
                return UIColor.orange300()
            case .Winter:
                return UIColor.cyan150()
            }
        }
    }
    
    var nearMountainColor: UIColor {
        get {
            switch season! {
            case .Spring:
                return UIColor.green300()
            case .Summer:
                return UIColor.orange300()
            case .Fall:
                return UIColor.orange600()
            case .Winter:
                return UIColor.cyan300()
            }
        }
    }
    
    var hillColor: UIColor {
        get {
            switch season! {
            case .Spring:
                return UIColor.green500()
            case .Summer:
                return UIColor.orange100()
            case .Fall:
                return UIColor.orange800()
            case .Winter:
                return UIColor.cyan50()
            }
        }
    }
    
    var precipitationType = PrecipitationType.None
    
//    static func forestDaytime() -> Environment {
//        return Environment(time: .Day, skyColor: UIColor.green50(), distantMountainColor: UIColor.green150(), nearMountainColor: UIColor.green300(), hillColor: UIColor.green500(), precipitationType: .None)
//    }
//    
//    static func snowDaytime() -> Environment {
//        return Environment(time: .Day, skyColor: UIColor.cyan100(), distantMountainColor: UIColor.cyan150(), nearMountainColor: UIColor.cyan300(), hillColor: UIColor.cyan50(), precipitationType: .Snow)
//    }
}
