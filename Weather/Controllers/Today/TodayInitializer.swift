//
//  TodayInitializer.swift
//  Weather
//
//  Created by David Tomić on 18.09.2021..
//

import Foundation

extension TodayViewController {
    
    func setup() {
        let viewController = self
        let dataStore = FirebaseDataStore()
        let interactor = TodayInteractor()
        let presenter = TodayPresenter()
        viewController.interactor = interactor
        interactor.dataStore = dataStore
        interactor.presenter = presenter
        presenter.displayController = viewController
    }
}
