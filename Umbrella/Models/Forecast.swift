//
//  Forecast.swift
//  Umbrella
//
//  Created by Greg Silesky on 9/22/19.
//  Copyright © 2019 The Nerdery. All rights reserved.
//

import Foundation

struct Forecast {
    let date: Date
    let hourlyCondition : [Condition]
    
    init(date: Date, hourlyCondition : [Condition]) {
        self.date = date
        var hourlyCondition = hourlyCondition.sorted { (a, b) -> Bool in
            return a.date < b.date
        }
        
        if let max = hourlyCondition.max(by: { (a, b) -> Bool in
            return a.temperature < b.temperature
        }), let firstIndexOfWarm = hourlyCondition.firstIndex(where: { (condition) -> Bool in
            return condition.temperature == max.temperature
        }){
            hourlyCondition[firstIndexOfWarm].isWarmest = true
        }
        
        if let min = hourlyCondition.min(by: { (a, b) -> Bool in
            return a.temperature < b.temperature
        }), let firstIndexOfCool = hourlyCondition.firstIndex(where: { (condition) -> Bool in
            return condition.temperature == min.temperature
        }){
            hourlyCondition[firstIndexOfCool].isCoolest = true
        }
        self.hourlyCondition = hourlyCondition
    }
}
