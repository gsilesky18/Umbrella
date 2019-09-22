//
//  Condition.swift
//  Umbrella
//
//  Created by Greg Silesky on 9/22/19.
//  Copyright © 2019 The Nerdery. All rights reserved.
//

import Foundation

struct Condition {
    let date : Date
    let summary: String
    let icon: String
    let temperature: Int
    var isWarmest: Bool = false
    var isCoolest: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case time
        case summary
        case icon
        case temperature
    }
}

extension Condition: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let timeInterval = try values.decode(TimeInterval.self, forKey: .time)
        self.date =  Date(timeIntervalSince1970: timeInterval)
        self.summary = try values.decode(String.self, forKey: .summary)
        self.icon = try values.decode(String.self, forKey: .icon)
        let temp = try values.decode(Double.self, forKey: .temperature)
        self.temperature = Int(temp.rounded())
    }
}
