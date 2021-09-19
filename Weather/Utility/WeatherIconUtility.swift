//
//  weatherIconUtility.swift
//  Weather
//
//  Created by David Tomić on 19.09.2021..
//

import UIKit

struct WeatherIconUtility {
    
    func getIconImage(iconId: String?) -> UIImage? {
        
        switch iconId {
        case "03d", "03n", "04d":
            return R.image.overcastClouds()
        case "04n", "02d", "02n":
            return R.image.scatteredClouds()
        case "10n", "10d":
            return R.image.rain()
        default:
            return R.image.sun()
        }
    }
}
