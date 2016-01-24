//
//  Environment.swift
//  Alpine
//
//  Created by Jack Cook on 1/23/16.
//  Copyright © 2016 Jack Cook. All rights reserved.
//

import MaterialColors
import UIKit

struct Environment {
    
    var time: Time?
    
    enum Time {
        case Day
        case Night
    }
    
    var season: Season?
    
    enum Season: Int {
        case Spring = 0
        case Summer
        case Fall
        case Winter
    }
    
    var skyColor: UIColor {
        get {
            switch time! {
            case .Night:
                return MaterialColors.BlueGrey.P800.color
            default:
                break
            }
            
            switch season! {
            case .Winter:
                return MaterialColors.Cyan.P50.color
            default:
                return MaterialColors.Cyan.P100.color
            }
        }
    }
    
    var distantMountainColor: UIColor {
        get {
            switch time! {
            case .Night:
                switch season! {
                case .Spring:
                    return MaterialColors.Green.P800.color
                case .Summer:
                    return MaterialColors.Cyan.P900.color
                case .Fall:
                    return UIColor(red: 37/255, green: 10/255, blue: 70/255, alpha: 1)
                case .Winter:
                    return MaterialColors.Cyan.P900.color
                }
            default:
                break
            }
            
            switch season! {
            case .Spring:
                return MaterialColors.Green.P100.color
            case .Summer:
                return MaterialColors.Blue.P700.color
            case .Fall:
                return MaterialColors.Orange.P300.color
            case .Winter:
                return UIColor(red: 153/255, green: 228/255, blue: 238/255, alpha: 1)
            }
        }
    }
    
    var nearMountainColor: UIColor {
        get {
            switch time! {
            case .Night:
                switch season! {
                case .Spring:
                    return MaterialColors.Green.P700.color
                case .Summer:
                    return MaterialColors.Teal.P900.color
                case .Fall:
                    return MaterialColors.Pink.P900.color
                case .Winter:
                    return MaterialColors.Cyan.P700.color
                }
            default:
                break
            }
            
            switch season! {
            case .Spring:
                return MaterialColors.Green.P300.color
            case .Summer:
                return MaterialColors.Cyan.P900.color
            case .Fall:
                return MaterialColors.Orange.P600.color
            case .Winter:
                return MaterialColors.Cyan.P300.color
            }
        }
    }
    
    var hillColor: UIColor {
        get {
            switch precipitationType! {
            case .Snow:
                return MaterialColors.Cyan.P50.color
            default:
                break
            }
            
            switch time! {
            case .Night:
                switch season! {
                case .Spring:
                    return MaterialColors.Green.P500.color
                case .Summer:
                    return MaterialColors.LightGreen.P900.color
                case .Fall:
                    return MaterialColors.DeepOrange.P900.color
                case .Winter:
                    return MaterialColors.BlueGrey.P600.color
                }
            default:
                break
            }
            
            switch season! {
            case .Spring:
                return MaterialColors.Green.P600.color
            case .Summer:
                return MaterialColors.LightGreen.P800.color
            case .Fall:
                return MaterialColors.Orange.P800.color
            case .Winter:
                return MaterialColors.BlueGrey.P700.color
            }
        }
    }
    
    var precipitationType: PrecipitationType?
}
