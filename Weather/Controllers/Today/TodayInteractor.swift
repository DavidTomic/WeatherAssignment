//
//  TodayInteractor.swift
//  Weather
//
//  Created by David Tomić on 18.09.2021..
//

import Foundation
import Network

protocol TodayBusinessLogic {
    func fetchTodayWeather()
    func shareWeatherInfo()
}

class TodayInteractor: TodayBusinessLogic {
    
    var presenter: TodayPresenter?
    var weather: CurrentWeather?
    private let locationUtility = LocationUtility()
    
    init() {
        setupLocationUpdatesListener()
        setupNetworkMonitor()
    }
    
    var dataStore: DataStore? {
        didSet {
            dataStore?.subscribeForCurrentWeatherDataUpdates { [weak self] weather in
                self?.weather = weather
                self?.presenter?.presentCurrentWeather(weather: weather)
            }
        }
    }
    
    private func setupLocationUpdatesListener() {
        locationUtility.onLocationRefresh = { [weak self] _ in
            self?.fetchTodayWeather()
        }
        if !locationUtility.hasLocationPermission {
            locationUtility.requestWhenInUseAuthorization()
        }
    }
    
    private func setupNetworkMonitor() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.presenter?.presentOfflineText(hasNetworkConnection: path.status == .satisfied)
            }
            if path.status == .satisfied {
                self?.fetchTodayWeather()
            }
        }
        let queue = DispatchQueue(label: "Network")
        monitor.start(queue: queue)
    }
    
    func fetchTodayWeather() {
        let currentLocation = locationUtility.currentLocation.coordinate
        dataStore?.getCurrentWeatherData(latitude: currentLocation.latitude,
                                         longitude: currentLocation.longitude,
                                         completion: { [weak self] weather in
                                            self?.weather = weather
                                            self?.presenter?.presentCurrentWeather(weather: weather)
                                         })
    }
    
    func shareWeatherInfo() {
        if let weather = weather {
            presenter?.presentShareMenu(weather: weather)
        }
    }
}
