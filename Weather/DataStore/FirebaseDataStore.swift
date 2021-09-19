//
//  FirebaseDataStore.swift
//  Weather
//
//  Created by David Tomić on 18.09.2021..
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol DataStore {
    func getCurrentWeatherData(latitude: Double, longitude: Double, completion: @escaping (CurrentWeather) -> Void)
    func subscribeForCurrentWeatherDataUpdates(completion: @escaping (CurrentWeather) -> Void)
    func getForecastData(latitude: Double, longitude: Double, completion: @escaping (ForecastGroup) -> Void)
    func subscribeForForecastDataUpdates(completion: @escaping (ForecastGroup) -> Void)
}

class FirebaseDataStore: DataStore {
    
    private enum Constants {
        static let firestoreCollection = "UsersWheatherData"
        static let firebaseUserIdKey = "firebase_user_id"
        static let baseUrl = "https://community-open-weather-map.p.rapidapi.com"
        static let headers = [
            "x-rapidapi-host": "community-open-weather-map.p.rapidapi.com",
            "x-rapidapi-key": "95dab7f5admsh355b4ea54d84affp1801fdjsn135fe8afe61c"
        ]
    }
    
    private let firebaseUserId: String
    private let firestoreDB = Firestore.firestore()
    private let jsonDecoder = JSONDecoder()
    
    private var firebaseCurrentWeatherDocument: DocumentReference {
        return firestoreDB.document("\(Constants.firestoreCollection)/\(firebaseUserId)-current")
    }
    
    private var firebaseForecastWeatherDocument: DocumentReference {
        return firestoreDB.document("\(Constants.firestoreCollection)/\(firebaseUserId)-forecast")
    }
    
    init() {
        var userId = UserDefaults.standard.string(forKey: Constants.firebaseUserIdKey)
        if userId == nil {
            userId = UUID().uuidString
            UserDefaults.standard.setValue(userId, forKey: Constants.firebaseUserIdKey)
        }
        firebaseUserId = userId ?? ""
        
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        firestoreDB.settings = settings
    }
    
    // MARK: Current weather data
    
    func getCurrentWeatherData(latitude: Double, longitude: Double, completion: @escaping (CurrentWeather) -> Void) {
        print("getCurrentWeatherData")
        firebaseCurrentWeatherDocument.getDocument { [weak self] snapshot, error in
            if let weather = try? snapshot?.data(as: CurrentWeather.self), error == nil {
                completion(weather)
            }
            self?.fetchNewCurrentWeatherData(latitude: latitude, longitude: longitude)
        }
    }
    
    func subscribeForCurrentWeatherDataUpdates(completion: @escaping (CurrentWeather) -> Void) {
        firebaseCurrentWeatherDocument.addSnapshotListener { snapshot, error in
            if let weather = try? snapshot?.data(as: CurrentWeather.self), error == nil {
                print("subscribeForCurrentWeatherDataUpdates completion")
                completion(weather)
            }
        }
    }
    
    private func fetchNewCurrentWeatherData(latitude: Double, longitude: Double) {
        print("fetchNewCurrentWeatherData")

        let request = NSMutableURLRequest(url: NSURL(string: "\(Constants.baseUrl)/weather?units=metric&lat=\(latitude)&lon=\(longitude)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = Constants.headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { [weak self] (data, _, error) -> Void in
            if let data = data, error == nil,
               let weather = try? self?.jsonDecoder.decode(CurrentWeatherApi.self, from: data) {
                self?.saveWeatherCurrentDataToFirebase(weather: weather.currentWeather)
            } else {
                self?.showError()
            }
        })
        
        dataTask.resume()
    }
    
    private func saveWeatherCurrentDataToFirebase(weather: CurrentWeather) {
        print("saveWeatherCurrentDataToFirebase")
        try? firebaseCurrentWeatherDocument.setData(from: weather)
    }
    
    // MARK: Forecast data
    
    func getForecastData(latitude: Double, longitude: Double, completion: @escaping (ForecastGroup) -> Void) {
        print("getForecastData")

        firebaseForecastWeatherDocument.getDocument { [weak self] snapshot, error in
            if let forecastData = try? snapshot?.data(as: ForecastGroup.self), error == nil {
                completion(forecastData)
            }
            self?.fetchNewForecastData(latitude: latitude, longitude: longitude)
        }
    }
    
    func subscribeForForecastDataUpdates(completion: @escaping (ForecastGroup) -> Void) {
        firebaseForecastWeatherDocument.addSnapshotListener { snapshot, error in
            if let forecastData = try? snapshot?.data(as: ForecastGroup.self), error == nil {
                print("subscribeForForecastDataUpdates completion")

                completion(forecastData)
            }
        }
    }
    
    private func fetchNewForecastData(latitude: Double, longitude: Double) {
        print("fetchNewForecastData")

        let request = NSMutableURLRequest(url: NSURL(string: "\(Constants.baseUrl)/forecast?units=metric&lat=\(latitude)&lon=\(longitude)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = Constants.headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { [weak self] (data, _, error) -> Void in
            if let data = data, error == nil,
               let forecast = try? self?.jsonDecoder.decode(ForecastDataApi.self, from: data) {
                let firestoreForecast = ForecastGroup(locationName: forecast.locationName, forecasts: forecast.forecasts)
                self?.saveForecastDataToFirebase(forecast: firestoreForecast)
            } else {
                self?.showError()
            }
        })
        
        dataTask.resume()
    }
    
    private func saveForecastDataToFirebase(forecast: ForecastGroup) {
        print("saveForecastDataToFirebase")

        try? firebaseForecastWeatherDocument.setData(from: forecast)
    }
    
    private func showError() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: R.string.localizable.generic_error(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: R.string.localizable.generic_ok(), style: .default, handler: nil))
            alert.show()
        }
    }
}
