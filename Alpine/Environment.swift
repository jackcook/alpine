//
//  Environment.swift
//  Alpine
//
//  Created by Jack Cook on 1/23/16.
//  Copyright © 2016 Jack Cook. All rights reserved.
//

import UIKit

struct Environment {
    
    var time: Time
    
    enum Time {
        case Day
        case Night
    }
    
    var skyColor: UIColor
    var distantMountainColor: UIColor
    var nearMountainColor: UIColor
    var hillColor: UIColor
    
    var precipitationType: PrecipitationType
    
    static func forestDaytime() -> Environment {
        return Environment(time: .Day, skyColor: UIColor.teal100(), distantMountainColor: UIColor.teal150(), nearMountainColor: UIColor.teal300(), hillColor: UIColor.teal50(), precipitationType: .Snow)
    }
    
    static func snowDaytime() -> Environment {
        return Environment(time: .Day, skyColor: UIColor.cyan100(), distantMountainColor: UIColor.cyan150(), nearMountainColor: UIColor.cyan300(), hillColor: UIColor.cyan50(), precipitationType: .Snow)
    }
}
