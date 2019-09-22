//
//  DarkSkyResponse.swift
//  Umbrella
//
//  Created by Greg Silesky on 9/16/19.
//  Copyright © 2019 The Nerdery. All rights reserved.
//

import Foundation

struct DarkSkyResponse {
    let currently : Condition
    let forecasts: [Forecast]
    
    enum CodingKeys: String, CodingKey {
        case currently
        case hourly
    }
    
    struct Hourly: Decodable {
        let data: [Condition]
        
        enum CodingKeys: String, CodingKey {
            case data
        }
    }
}

extension DarkSkyResponse: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.currently = try values.decode(Condition.self, forKey: .currently)
        let hourly = try values.decode(Hourly.self, forKey: .hourly)
        let gregorian = Calendar(identifier: .gregorian)
        let byDate: [Date: [Condition]] = hourly.data.reduce(into: [:], { (byDay, condition) in
            let components = gregorian.dateComponents([.year, .month, .day], from: condition.date)
            let date = gregorian.date(from: components)!
            let existing = byDay[date] ?? []
            byDay[date] = existing + [condition]
        })
        self.forecasts = byDate.compactMap { (key: Date, value: [Condition]) -> Forecast in
            Forecast(date: key, hourlyCondition: value)
        }
    }
}
