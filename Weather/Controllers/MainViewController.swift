//
//  MainViewController.swift
//  Weather
//
//  Created by David Tomić on 18.09.2021..
//

import UIKit

class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        let todayScreen = TodayViewController()
        todayScreen.edgesForExtendedLayout = []
        todayScreen.title = R.string.localizable.tab_bar_item_title_today()
        
        let forecastScreen = ForecastViewController()
        forecastScreen.edgesForExtendedLayout = []
        forecastScreen.title = R.string.localizable.tab_bar_item_title_forecast()
        
        setViewControllers([todayScreen, forecastScreen], animated: false)
        
        if let todayTabBarItem = tabBar.items?.first {
            todayTabBarItem.image = R.image.tab_item_today()
        }
        if let forecatsTabBarItem = tabBar.items?.last {
            forecatsTabBarItem.image = R.image.tab_item_forecast()
        }
    }
}
