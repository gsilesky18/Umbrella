//
//  DarkSkyApi.swift
//  Umbrella
//
//  Created by Greg Silesky on 9/16/19.
//  Copyright © 2019 The Nerdery. All rights reserved.
//

import Alamofire
import Siesta

class DarkSkyApi: Service {
    //Singleton instance of API
    static let sharedInstance = DarkSkyApi()
    
    // API Key for the request
    let apiKey = "a913259886e00a06f657f0fd9a6a30ad"
    
    fileprivate init(){
        //Siesta init
        super.init(baseURL: "https://api.darksky.net", standardTransformers: [.text, .image], networking: Alamofire.SessionManager.default)
        
        //Mapping from specific paths to models
        let jsonDecoder = JSONDecoder()
        configureTransformer("/forecast/**") {
            try jsonDecoder.decode(DarkSkyResponse.self, from: $0.content)
        }
    }
    
    func getForcastResource(latitude: Double, longitude: Double) -> Resource {
        return resource("/forecast").child(apiKey).child("\(latitude),\(longitude)").withParam("exclude", "minutely,daily,alerts,flags").withParam("units", Preferences.sharedInstance.getUnits().apiValue)
    }
}
