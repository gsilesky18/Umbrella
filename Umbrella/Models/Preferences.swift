//
//  Preferences.swift
//  Umbrella
//
//  Created by Greg Silesky on 9/17/19.
//  Copyright © 2019 The Nerdery. All rights reserved.
//

import Foundation

struct Preferences {
    
    static let sharedInstance = Preferences()
    //Dictionary keys
    let (latitudeKey, longitudeKey, cityKey, stateKey) = ("latitude", "longitude", "city", "state")
    //UserDefault Keys
    let locationKey = "location"
    let unitsKey = "units"
    
    private init(){}
    
    func saveLocation(latitude: Double, longitude: Double, city: String, state: String){
        UserDefaults.standard.set([latitudeKey : latitude, longitudeKey : longitude, cityKey : city, stateKey : state], forKey: locationKey)
    }
    
    func saveUnits(units : WeatherRequestUnits){
        UserDefaults.standard.set(units.rawValue, forKey: unitsKey)
    }
    
    func getLocation() -> Location{
        return Location(dictionary: UserDefaults.standard.dictionary(forKey: locationKey) ?? [:])
    }
    
    func getUnits() -> WeatherRequestUnits {
        return WeatherRequestUnits(rawValue: UserDefaults.standard.integer(forKey: unitsKey)) ?? WeatherRequestUnits.imperial
    }
}
