//
//  TodayViewController.swift
//  Weather
//
//  Created by David Tomić on 18.09.2021..
//

import UIKit

protocol TodayDisplayLogic {
    func displayTodayWeather(viewModel: TodayWeatherViewModel)
}

struct TodayWeatherViewModel {
    let weatherImage: UIImage?
    let location: String
    let temperature: String
    let weatherDetails: [WeatherDetailModel]
    let shareTitle: String
}

class TodayViewController: UIViewController, TodayDisplayLogic {
    
    let screenTitleView = ScreenTitleView()
    let imageViewWeather = UIImageView()
    let lblLocation = UILabel()
    let lblTemperature = UILabel()
    let btnShare = UIButton()
    let weatherDetailsView = WeatherDetailsView()
    
    var interactor: TodayBusinessLogic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.fetchTodayWeather()
    }
    
    func displayTodayWeather(viewModel: TodayWeatherViewModel) {
        screenTitleView.title = self.title
        imageViewWeather.style(image: viewModel.weatherImage)
        lblLocation.style(text: viewModel.location)
        lblTemperature.style(text: viewModel.temperature)
        btnShare.style(title: viewModel.shareTitle)
        weatherDetailsView.viewModel = viewModel.weatherDetails
    }
}
