//
//  LocationUtility.swift
//  Weather
//
//  Created by David Tomić on 18.09.2021..
//

import Foundation
import CoreLocation

class LocationUtility: NSObject {
    
    private enum Constants {
        static let predefinedLocation = CLLocation(latitude: 45.8, longitude: 16.0)
    }
    
    private let locationManager = CLLocationManager()
    var onLocationRefresh: ((CLLocation) -> Void)?
    private var currentFreshLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestLocation()
    }
    
    var hasLocationPermission: Bool {
        return CLLocationManager.authorizationStatus() == .authorizedAlways ||
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
    
    var currentLocation: CLLocation {
        return currentFreshLocation ?? locationManager.location ?? Constants.predefinedLocation
    }
    
    func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
}

extension LocationUtility: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        var needRefreshLocation = currentFreshLocation == nil
        
        if !needRefreshLocation, let currentFreshLocation = currentFreshLocation,
           location.distance(from: currentFreshLocation) > 1000 {
            needRefreshLocation = true
        }
        
        if needRefreshLocation {
            currentFreshLocation = location
            onLocationRefresh?(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) { }
}
