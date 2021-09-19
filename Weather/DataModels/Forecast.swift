//
//  Forecast.swift
//  Weather
//
//  Created by David Tomić on 19.09.2021..
//

import Foundation

struct ForecastDataApi: Codable {
    
    private enum RootKeys: String, CodingKey {
        case city
        case list
    }
    
    private enum CityKeys: String, CodingKey {
        case name
    }
    
    var locationName: String?
    let forecasts: [Forecast]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        
        if let cityContainer = try? container.nestedContainer(keyedBy: CityKeys.self, forKey: .city) {
            locationName = try? cityContainer.decode(String.self, forKey: .name)
        }
        
        var weatherContainerArray = try container.nestedUnkeyedContainer(forKey: .list)
        var forecasts = [Forecast]()
        
        while !weatherContainerArray.isAtEnd {
            var temperature: Float?
            var iconId: String?
            var description: String?
            var date: Date?
            
            if let weather = try? weatherContainerArray.decode(CurrentWeatherApi.self) {
                temperature = weather.temperature
                iconId = weather.iconId
                description = weather.weatherDescription
                date = weather.date
            }

            forecasts.append(Forecast(iconId: iconId, dateTime: date, weatherDescription: description, temperature: temperature))
        }
        
        self.forecasts = forecasts
    }
}

struct ForecastGroup: Codable {
    var locationName: String?
    let forecasts: [Forecast]
}

struct Forecast: Codable {
    var iconId: String?
    var dateTime: Date?
    var weatherDescription: String?
    var temperature: Float?
}
