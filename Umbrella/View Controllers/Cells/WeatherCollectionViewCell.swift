//
//  WeatherCollectionViewCell.swift
//  Umbrella
//
//  Created by Greg Silesky on 9/19/19.
//  Copyright © 2019 The Nerdery. All rights reserved.
//

import UIKit
import Siesta

class WeatherCollectionViewCell: UICollectionViewCell {

    static let kWeatherCollectionViewCell = "kWeatherCollectionViewCell"
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var iconImage: RemoteImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
}
