//
//  DarkSkyResponse.swift
//  Umbrella
//
//  Created by Greg Silesky on 9/16/19.
//  Copyright © 2019 The Nerdery. All rights reserved.
//

import Foundation

struct DarkSkyResponse : Codable {
    let currently: Forecast
    let hourly: Hourly
    
    struct Hourly: Codable {
        let data: [Forecast]
    }
}

struct Forecast: Codable  {
    let time: TimeInterval
    let summary: String
    let icon: String
    let temperature: Double
}
