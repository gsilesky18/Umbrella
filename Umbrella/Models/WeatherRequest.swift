//
//  WeatherRequest.swift
//  Umbrella
//
//  Created by Jon Rexeisen on 10/13/15.
//  Copyright © 2015 The Nerdery. All rights reserved.
//

import Foundation

/// Struct that builds the URL to send to the server for parsing.  Call the getter to URL for the fully qualified URL.
struct WeatherRequest {
    
    /// API Key for the request
    private let apiKey: String
    
    /// The location of the request
    var location: WeatherRequestLocation?
    
    /// The requested format of the returned weather
    var units: WeatherRequestUnits = .imperial
    
    /// Fully qualified URL for the request
    var url: Foundation.URL? {
        get {
            /// If there is no location, there is no url
            guard let location = location else {
                return nil
            }
            
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "api.darksky.net"
            urlComponents.path = "/forecast/\(apiKey)/\(location.latitude),\(location.longitude)"
            urlComponents.query = "exclude=minutely,daily,alerts,flags&units=\(units.apiValue)"
            return urlComponents.url
        }
    }
    
    /// Initializer
    ///
    /// - Parameter APIKey: The API Key for Dark Sky.
    /// - Returns: The initialized object.
    init(APIKey: String) {
        self.apiKey = APIKey
    }
}
