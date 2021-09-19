//
//  TodayViewController+Layout.swift
//  Weather
//
//  Created by David Tomić on 18.09.2021..
//

import UIKit

extension TodayViewController {
    
    func setupView() {
        screenTitleView.style(parentView: view)
            .styleMakeConstraints { make in
                make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            }
        
        let vStack = UIStackView()
            .style(axis: .vertical)
            .style(distribution: .equalSpacing)
            .style(parentView: view)
            .styleMakeConstraints { make in
                make.top.equalTo(screenTitleView.snp.bottom)
                make.leading.bottom.trailing.equalToSuperview()
            }
        
        // using helper view to better support equalSpacing
        UIView().style(parentView: vStack)
            .styleMakeConstraints { make in
                make.height.equalTo(1)
            }
        
        createTopView(parentView: vStack)
        weatherDetailsView.style(parentView: vStack)
        
        btnShare.style(parentView: vStack)
            .style(titleColor: .systemOrange)
            .style(target: self, action: #selector(onShareButtonClick))
        
        // using helper view to better support equalSpacing
        UIView().style(parentView: vStack)
            .styleMakeConstraints { make in
                make.height.equalTo(1)
            }
        
        lblOffline.style(parentView: view)
            .style(textAlignment: .center)
            .style(textColor: .lightGray)
            .styleMakeConstraints { make in
                make.leading.bottom.trailing.equalTo(view.safeAreaInsets).inset(10)
            }
    }
    
    private func createTopView(parentView: UIView) {
        let topVStack = UIStackView()
            .style(axis: .vertical)
            .style(alignment: .center)
            .style(spacing: 10)
            .style(parentView: parentView)
        
        imageViewWeather.style(contentMode: .scaleAspectFit)
            .style(parentView: topVStack)
            .styleMakeConstraints { make in
                make.size.equalTo(100)
            }
        lblLocation.style(parentView: topVStack)
        lblTemperature.style(parentView: topVStack)
            .style(textColor: .systemBlue)
            .style(font: UIFont.systemFont(ofSize: 20))
    }
}

class WeatherDetailsView: UIView {
    
    private let vStack = UIStackView()
    private let topLine = UIView()
    private let bottomLine = UIView()
    
    var viewModel: [WeatherDetailModel] = [] {
        didSet {
            updateUI()
        }
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        topLine.style(parentView: self)
            .style(isHidden: true)
            .style(backgroundColor: .lightGray.withAlphaComponent(0.5))
            .styleMakeConstraints { make in
                make.height.equalTo(1)
                make.width.equalTo(150)
                make.top.centerX.equalToSuperview()
            }
        
        bottomLine.style(parentView: self)
            .style(isHidden: true)
            .style(backgroundColor: .lightGray.withAlphaComponent(0.5))
            .styleMakeConstraints { make in
                make.height.equalTo(1)
                make.width.equalTo(150)
                make.bottom.centerX.equalToSuperview()
            }
        
        vStack.style(axis: .vertical)
            .style(spacing: 10)
            .style(parentView: self)
            .styleMakeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.top.equalTo(topLine).offset(25)
                make.bottom.equalTo(bottomLine).offset(-25)
            }
    }
    
    private func updateUI() {
        vStack.clearArrangedSubviews()
        topLine.style(isHidden: viewModel.count == 0)
        bottomLine.style(isHidden: viewModel.count == 0)
        
        var hStack = UIStackView()
        
        for index in 0..<viewModel.count {
            if index % 3 == 0 {
                let holderView = UIView().style(parentView: vStack)
                hStack = UIStackView().style(spacing: 80)
                    .style(parentView: holderView)
                    .styleMakeConstraints { make in
                        make.center.top.bottom.equalToSuperview()
                    }
            }
            WeatherDetailView(viewModel: viewModel[index]).style(parentView: hStack)
        }
    }
}

private class WeatherDetailView: UIView {
    
    private let imageView = UIImageView()
    private let lblTitle = UILabel()
    
    init(viewModel: WeatherDetailModel) {
        super.init(frame: .zero)
        setupView(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(viewModel: WeatherDetailModel) {
        let vStack = UIStackView()
            .style(axis: .vertical)
            .style(alignment: .center)
            .style(parentView: self)
            .styleMakeConstraints { make in
                make.edges.equalToSuperview()
            }
        
        let dashedView = RectangularDashedView()
            .style(parentView: vStack)
            .styleMakeConstraints { make in
                make.size.equalTo(25)
            }
        dashedView.dashWidth = 1
        dashedView.dashColor = .lightGray
        dashedView.dashLength = 2
        dashedView.betweenDashesSpace = 2
        dashedView.cornerRadius = 2
        
        imageView.style(contentMode: .scaleAspectFit)
            .style(image: viewModel.image)
            .style(parentView: dashedView)
            .styleMakeConstraints { make in
                make.edges.equalToSuperview()
            }
        
        lblTitle.style(parentView: vStack)
            .style(text: viewModel.title)
            .style(font: UIFont.systemFont(ofSize: 12))
            .style(textColor: .black)
    }
}
