//
//  WeatherRequestLocation.swift
//  Umbrella
//
//  Created by Erik Weiss on 8/13/18.
//  Copyright © 2018 The Nerdery. All rights reserved.
//

import Foundation

/// Structure representing the location of a weather request.
struct WeatherRequestLocation {

    /// The latitude of a location (in decimal degrees). Positive is north, negative is south.
    var latitude: Decimal

    /// The longitude of a location (in decimal degrees). Positive is east, negative is west.
    var longitude: Decimal
    
}
