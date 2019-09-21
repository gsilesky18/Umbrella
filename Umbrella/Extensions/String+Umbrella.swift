//
//  NSURL+Umbrella.swift
//  Umbrella
//
//  Created by Jon Rexeisen on 10/13/15.
//  Copyright © 2015 The Nerdery. All rights reserved.
//

import Foundation

extension String {
    
    /// Returns the URL for the images to be used within the application.
    ///
    /// - Parameter highlighted: If the image is filled in or not.
    /// - Returns: The URL string to be used within the application.
    func weatherIconURL(highlighted: Bool = false) -> String {
        if highlighted {
            return "https://codechallenge.nerderylabs.com/mobile-nat/\(self)-selected.png"
        } else {
            return "https://codechallenge.nerderylabs.com/mobile-nat/\(self).png"
        }
    }
    
}
