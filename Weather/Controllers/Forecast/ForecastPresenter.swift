//
//  ForecastPresenter.swift
//  Weather
//
//  Created by David Tomić on 19.09.2021..
//

import Foundation

protocol ForecastPresenterLogic {
    func presentForecast(forecastdata: ForecastGroup)
}

class ForecastPresenter: ForecastPresenterLogic {
    
    private let dateFormatter = DateFormatter()
    private let timeFormatter = DateFormatter()
    private let weatherIconUtility = WeatherIconUtility()
    
    var displayController: ForecastDisplayController?
    
    func presentForecast(forecastdata: ForecastGroup) {
        var forecasts = [ForecastSectionViewModel]()
        
        var currentDate = Date()
        var currentForecastArray = [Forecast]()
        
        forecastdata.forecasts.forEach {
            if isSameDay(date1: currentDate, date2: $0.dateTime ?? Date()) {
                currentForecastArray.append($0)
            } else {
                forecasts.append(ForecastSectionViewModel(title: getDayName(from: currentDate),
                                                          forecasts: foo(currentForecastArray)))
                currentForecastArray.removeAll()
                currentForecastArray.append($0)
                currentDate = $0.dateTime ?? Date()
            }
        }
        
        if currentForecastArray.count > 0 {
            forecasts.append(ForecastSectionViewModel(title: getDayName(from: currentDate),
                                                      forecasts: foo(currentForecastArray)))
        }

        let viewModel = ForecastDataViewControllerModel(locationName: forecastdata.locationName, tableData: forecasts)
        displayController?.displayForecast(viewModel: viewModel)
    }
    
    private func foo(_ currentForecastArray: [Forecast]) -> [ForecastViewModel] {
        return currentForecastArray.map {
            let image = weatherIconUtility.getIconImage(iconId: $0.iconId)
            let temperature = "\(Int($0.temperature ?? 0))°C"
            timeFormatter.dateFormat = "HH:mm"
            let time = timeFormatter.string(from: $0.dateTime ?? Date())
            return ForecastViewModel(icon: image, time: time, description: $0.weatherDescription, temperature: temperature)
        }
    }
    
    private func getDayName(from date: Date) -> String {
        if isSameDay(date1: Date(), date2: date) {
            return "TODAY"
        }
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date).uppercased()
    }
    
    private func isSameDay(date1: Date, date2: Date) -> Bool {
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }
}

private struct ForecastDataViewControllerModel: ForecastViewControllerModel {
    var locationName: String?
    var tableData: [ForecastSectionViewModel]
}
