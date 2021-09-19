//
//  CurrentWeather.swift
//  Weather
//
//  Created by David Tomić on 18.09.2021..
//

import Foundation

struct CurrentWeatherApi: Codable {
    
    private enum RootKeys: String, CodingKey {
        case name
        case main
        case visibility
        case wind
        case clouds
        case weather
    }
    
    private enum MainKeys: String, CodingKey {
        case pressure
        case humidity
        case temperature = "temp"
    }
    
    private enum WeatherKeys: String, CodingKey {
        case main
    }
    
    private enum WindKeys: String, CodingKey {
        case speed
        case degree = "deg"
    }
    
    private enum CloudsKeys: String, CodingKey {
        case cloudity = "all"
    }
    
    var name: String?
    var pressure: Int?
    var humidityPercentage: Int?
    var temperature: Float?
    var windSpeed: Float?
    var windDegree: Int?
    var cloudsPercentage: Int?
    var visibility: Int?
    var weatherDescription: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        name = try? container.decode(String.self, forKey: .name)
        visibility = try? container.decode(Int.self, forKey: .visibility)
        
        if var weatherContainerArray = try? container.nestedUnkeyedContainer(forKey: .weather) {
            if let weatherContainer = try? weatherContainerArray.nestedContainer(keyedBy: WeatherKeys.self) {
                weatherDescription = try? weatherContainer.decode(String.self, forKey: .main)
            }
        }
        
        if let mainContainer = try? container.nestedContainer(keyedBy: MainKeys.self, forKey: .main) {
            pressure = try? mainContainer.decode(Int.self, forKey: .pressure)
            humidityPercentage = try? mainContainer.decode(Int.self, forKey: .humidity)
            temperature = try? mainContainer.decode(Float.self, forKey: .temperature)
        }
        
        if let windContainer = try? container.nestedContainer(keyedBy: WindKeys.self, forKey: .wind) {
            windSpeed = try? windContainer.decode(Float.self, forKey: .speed)
            windDegree = try? windContainer.decode(Int.self, forKey: .degree)
        }
        
        if let cloudsContainer = try? container.nestedContainer(keyedBy: CloudsKeys.self, forKey: .clouds) {
            cloudsPercentage = try? cloudsContainer.decode(Int.self, forKey: .cloudity)
        }
    }
    
    var currentWeather: CurrentWeather {
        return CurrentWeather(name: self.name,
                              pressure: self.pressure,
                              humidityPercentage: self.humidityPercentage,
                              temperature: self.temperature,
                              windSpeed: self.windSpeed,
                              windDegree: self.windDegree,
                              cloudsPercentage: self.cloudsPercentage,
                              visibility: self.visibility,
                              weatherDescription: self.weatherDescription)
    }
}

struct CurrentWeather: Codable {
    var name: String?
    var pressure: Int?
    var humidityPercentage: Int?
    var temperature: Float?
    var windSpeed: Float?
    var windDegree: Int?
    var cloudsPercentage: Int?
    var visibility: Int?
    var weatherDescription: String?
}
