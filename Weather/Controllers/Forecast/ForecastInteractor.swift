//
//  ForecastInteractor.swift
//  Weather
//
//  Created by David Tomić on 19.09.2021..
//

import Foundation

protocol ForecastBusinessLogic {
    func fetchForecast()
}

class ForecastInteractor: ForecastBusinessLogic {
    
    private let locationUtility = LocationUtility()
    var presenter: ForecastPresenter?
    
    var dataStore: DataStore? {
        didSet {
            dataStore?.subscribeForForecastDataUpdates { [weak self] forecastData in
                self?.presenter?.presentForecast(forecastdata: forecastData)
            }
        }
    }
    
    func fetchForecast() {
        let currentLocation = locationUtility.currentLocation.coordinate
        dataStore?.getForecastData(latitude: currentLocation.latitude,
                                   longitude: currentLocation.longitude) { [weak self] forecastData in
            self?.presenter?.presentForecast(forecastdata: forecastData)
        }
    }
}
