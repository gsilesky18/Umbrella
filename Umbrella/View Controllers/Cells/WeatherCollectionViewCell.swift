//
//  WeatherCollectionViewCell.swift
//  Umbrella
//
//  Created by Greg Silesky on 9/19/19.
//  Copyright © 2019 The Nerdery. All rights reserved.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {

    static let kWeatherCollectionViewCell = "kWeatherCollectionViewCell"
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var iconImage: UmbrellaImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    var condition: Condition? {
        didSet{
            if let condition = condition {
                timeLabel.text = condition.date.toShortTime()
                temperatureLabel.text = "\(condition.temperature)˚"
                if condition.isWarmest {
                    iconImage.imageColor = UIColor(0xFF9800)
                }else if condition.isCoolest {
                    iconImage.imageColor = UIColor(0x03A9F4)
                }else{
                    iconImage.imageColor = UIColor.black
                }
                iconImage.imageURL = condition.icon.weatherIconURL(highlighted: (condition.isWarmest || condition.isCoolest))
            }
        }
    }
    
}
