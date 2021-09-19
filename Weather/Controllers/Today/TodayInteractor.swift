//
//  TodayInteractor.swift
//  Weather
//
//  Created by David Tomić on 18.09.2021..
//

import Foundation
import Network
import CoreLocation

protocol TodayBusinessLogic {
    func fetchTodayWeather()
    func shareWeatherInfo()
}

class TodayInteractor: TodayBusinessLogic {
    
    var presenter: TodayPresenter?
    var weather: CurrentWeather?
    private let locationUtility = LocationUtility()
    private var networkStatus: NWPath.Status?
    
    private var lastFetchLocation: CLLocation?
    private var lastFetchedTimestamp: Date?
    
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
        locationUtility.onLocationRefresh = { [weak self] location in
            if let lastFetchLocation = self?.lastFetchLocation, location.distance(from: lastFetchLocation) > 1000 {
                self?.fetchTodayWeather()
            }
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
                
                if path.status == .satisfied, self?.networkStatus != nil {
                    self?.fetchTodayWeather()
                }
                self?.networkStatus = path.status
            }
        }
        let queue = DispatchQueue(label: "Network")
        monitor.start(queue: queue)
    }
    
    func fetchTodayWeather() {
        let currentLocation = locationUtility.currentLocation
        self.lastFetchLocation = currentLocation
        
        dataStore?.getCurrentWeatherData(latitude: currentLocation.coordinate.latitude,
                                         longitude: currentLocation.coordinate.longitude,
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
