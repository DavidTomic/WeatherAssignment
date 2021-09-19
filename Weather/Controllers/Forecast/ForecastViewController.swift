//
//  ForecastViewController.swift
//  Weather
//
//  Created by David Tomić on 18.09.2021..
//

import UIKit

protocol ForecastDisplayController {
    func displayForecast(viewModel: ForecastViewControllerModel)
}

protocol ForecastViewControllerModel {
    var locationName: String? { get }
    var tableData: [ForecastSectionViewModel] { get }
}

class ForecastViewController: UIViewController, ForecastDisplayController {
    
    let screenTitleView = ScreenTitleView()
    let tableview = UITableView()
    var tableviewModel = [ForecastSectionViewModel]()
    
    var interactor: ForecastBusinessLogic?
    
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
        interactor?.fetchForecast()
    }
    
    func displayForecast(viewModel: ForecastViewControllerModel) {
        screenTitleView.title = viewModel.locationName
        tableviewModel = viewModel.tableData
        tableview.reloadData()
    }
}
