//
//  Location.swift
//  Umbrella
//
//  Created by Greg Silesky on 9/18/19.
//  Copyright © 2019 The Nerdery. All rights reserved.
//

import Foundation

struct Location {
    let latitude: Double
    let longitude: Double
    let city: String
    let state: String
    
    init(dictionary: [String: Any]) {
        self.latitude = dictionary[Preferences.sharedInstance.latitudeKey] as? Double ?? 0
        self.longitude = dictionary[Preferences.sharedInstance.longitudeKey] as? Double ?? 0
        self.city = dictionary[Preferences.sharedInstance.cityKey] as? String ?? ""
        self.state = dictionary[Preferences.sharedInstance.stateKey] as? String ?? ""
    }
}
