//
//  TodayViewController.swift
//  Weather
//
//  Created by David Tomić on 18.09.2021..
//

import UIKit

protocol TodayDisplayController {
    func displayTodayWeather(viewModel: TodayViewControllerModel)
    func displayShareMenu(items: [Any])
    func displayOfflineLabel(text: String?)
}

protocol TodayViewControllerModel {
    var weatherImage: UIImage? { get }
    var location: String { get }
    var temperature: String { get }
    var weatherDetails: [WeatherDetailModel] { get }
    var shareTitle: String { get }
}

class TodayViewController: UIViewController, TodayDisplayController {
    
    let screenTitleView = ScreenTitleView()
    let imageViewWeather = AnimatedImageView()
    let lblLocation = UILabel()
    let lblTemperature = UILabel()
    let btnShare = UIButton()
    let lblOffline = UILabel()
    let weatherDetailsView = WeatherDetailsView()
    
    var interactor: TodayBusinessLogic?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
      setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.fetchTodayWeather()
    }
    
    @objc func onShareButtonClick() {
        interactor?.shareWeatherInfo()
    }
    
    func displayTodayWeather(viewModel: TodayViewControllerModel) {
        screenTitleView.title = self.title
        imageViewWeather.style(image: viewModel.weatherImage)
        lblLocation.style(text: viewModel.location)
        lblTemperature.style(text: viewModel.temperature)
        btnShare.style(title: viewModel.shareTitle)
        weatherDetailsView.viewModel = viewModel.weatherDetails
    }
    
    func displayShareMenu(items: [Any]) {
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activityViewController, animated: true)
    }
    
    func displayOfflineLabel(text: String?) {
        lblOffline.style(text: text)
    }
}
