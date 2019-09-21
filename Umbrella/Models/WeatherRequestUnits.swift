//
//  WeatherRequestUnits.swift
//  Umbrella
//
//  Created by Erik Weiss on 8/13/18.
//  Copyright © 2018 The Nerdery. All rights reserved.
//

import Foundation

/// Return weather conditions in the requested units.
enum WeatherRequestUnits: Int {
    
    // Return weather in degrees Fahrenheit
    case imperial = 0
    
    // Return weather in degrees Celsius
    case metric = 1
    
    /// Returns the appropriate query string parameter for Dark Sky
    var apiValue: String {
        switch self {
        case .imperial:
            return "us"
        case .metric:
            return "si"
        }
    }
}
