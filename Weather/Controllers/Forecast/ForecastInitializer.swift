//
//  ForecastInitializer.swift
//  Weather
//
//  Created by David Tomić on 19.09.2021..
//

extension ForecastViewController {
    
    func setup() {
        let viewController = self
        let dataStore = FirebaseDataStore()
        let interactor = ForecastInteractor()
        let presenter = ForecastPresenter()
        viewController.interactor = interactor
        interactor.dataStore = dataStore
        interactor.presenter = presenter
        presenter.displayController = viewController
    }
}
