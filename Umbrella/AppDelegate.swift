//
//  AppDelegate.swift
//  Umbrella
//
//  Created by Jon Rexeisen on 10/13/15.
//  Copyright © 2015 The Nerdery. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        fatalError("Look at me first")        
        // Our designer didn't use the actual degree symbol, but used the "ring above" symbol (option+K) ˚ instead
        // because he thought it looks better. You can use either ring above or the actual degree symbol (option-shift-8) °.
        // Throw a comment if you want on which you chose and why.
        
        // UIColors for the use for reference in the rest of the application:
        let warmColor = UIColor(0xFF9800)
        let coolColor = UIColor(0x03A9F4)
        
        // Setup the request:
        var weatherRequest = WeatherRequest(APIKey: "YOUR API KEY")
        
        // Set the location:
        weatherRequest.location = WeatherRequestLocation(latitude: 42.3601, longitude: -71.0589)
        // You might want to read about the CLGeocoder class to convert from Zip to Lat/Long,
        // as well as to get the City and State for display in the header.
        
        // Set the units:
        weatherRequest.units = .imperial
        
        // Here's your URL. Marshall this to the internet however you please:
        let url = weatherRequest.url
        
        // Here’s where to look for the information, because let’s be honest, you know how to read JSON
        // All values are as of August 13, 2018
        
        // Current Conditions
        // Temp         : currently.temperature
        // Condition    : currently.summary
        
        // Hourly information
        // Timestamp    : hourly.[x].time (UNIX time: seconds since midnight GMT on 1 Jan 1970)
        // Icon         : hourly.[x].icon
        // Temp         : hourly.[x].temperature
        
        // How to use the icon name to get the URL. Solid icons are used for the daily highs and lows:
        let solidIcon = "clear".weatherIconURL(highlighted: true)
        let outlineIcon = "clear".weatherIconURL()
        
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

}

