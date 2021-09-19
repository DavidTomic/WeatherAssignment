//
//  TodayPresenter.swift
//  Weather
//
//  Created by David Tomić on 18.09.2021..
//

import Foundation

protocol TodayPresenterLogic {
    func presentCurrentWeather(weather: CurrentWeather)
    func presentShareMenu(weather: CurrentWeather)
    func presentOfflineText(hasNetworkConnection: Bool)
}

class TodayPresenter: TodayPresenterLogic {
    
    var displayController: TodayDisplayController?
    
    func presentCurrentWeather(weather: CurrentWeather) {
        let formattedTemp = "\(Int(weather.temperature ?? 0))"
        var weatherDetails = [WeatherDetailModel]()
        
        if let cloudsPercentage = weather.cloudsPercentage {
            weatherDetails.append(WeatherDetailModel(image: R.image.clouds(), title: "\(cloudsPercentage)%"))
        }
        if let humidityPercentage = weather.humidityPercentage {
            weatherDetails.append(WeatherDetailModel(image: R.image.humidity(), title: "\(humidityPercentage)%"))
        }
        if let pressure = weather.pressure {
            weatherDetails.append(WeatherDetailModel(image: R.image.pressure(), title: "\(pressure) hPa"))
        }
        if let windSpeed = weather.windSpeed {
            weatherDetails.append(WeatherDetailModel(image: R.image.wind(), title: "\(Int(windSpeed)) km/h"))
        }
        if let windDegree = weather.windDegree {
            weatherDetails.append(WeatherDetailModel(image: R.image.compass(), title: "\(windDegree)°"))
        }

        let todayViewModel = TodayViewModel(weatherImage: R.image.sun(),
                                            location: "\(weather.name ?? "-")" ,
                                            temperature: "\(formattedTemp)°C | \(weather.weatherDescription?.capitalized ?? "")",
                                            weatherDetails: weatherDetails,
                                            shareTitle: R.string.localizable.btn_share())
        displayController?.displayTodayWeather(viewModel: todayViewModel)
    }
    
    func presentShareMenu(weather: CurrentWeather) {
        let formattedTemp = "\(Int(weather.temperature ?? 0))"
        let items = ["Hi, my current weather is \(weather.weatherDescription?.capitalized ?? "") with \(formattedTemp)°C"]
        displayController?.displayShareMenu(items: items)
    }
    
    func presentOfflineText(hasNetworkConnection: Bool) {
        displayController?.displayOfflineLabel(text: hasNetworkConnection ? nil : "showing offline data")
    }
}
