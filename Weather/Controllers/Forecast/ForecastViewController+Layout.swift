//
//  ForecastViewController+Layout.swift
//  Weather
//
//  Created by David Tomić on 19.09.2021..
//

import UIKit

extension ForecastViewController {
    
    func setupView() {
        screenTitleView.style(parentView: view)
            .styleMakeConstraints { make in
                make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            }
        
        tableview.style(parentView: view)
            .styleMakeConstraints { make in
                make.top.equalTo(screenTitleView.snp.bottom)
                make.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
            }
        
        tableview.dataSource = self
        tableview.delegate = self
        tableview.separatorColor = .clear
        tableview.register(TableViewHeader.self, forHeaderFooterViewReuseIdentifier: String(describing: TableViewHeader.self))
        tableview.register(TableViewCell.self, forCellReuseIdentifier: String(describing: TableViewCell.self))
    }
}

extension ForecastViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: TableViewHeader.self)) as? TableViewHeader
        header?.title = tableviewModel[section].title
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableviewModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableviewModel[section].forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TableViewCell.self), for: indexPath) as? TableViewCell
        let forecasts = tableviewModel[indexPath.section].forecasts
        let isLastRow = indexPath.row == forecasts.count - 1
        cell?.configure(model: tableviewModel[indexPath.section].forecasts[indexPath.row], isLastRow: isLastRow)
        return cell ?? UITableViewCell()
    }
}

private class TableViewCell: UITableViewCell {
        
    private let imageViewWeather = UIImageView()
    private let lblTime = UILabel()
    private let lblDescription = UILabel()
    private let lblTemperature = UILabel()
    
    private let fullLine = UIView()
    private let shortLine = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        imageViewWeather.style(parentView: contentView)
            .style(contentMode: .scaleAspectFit)
            .styleMakeConstraints { make in
                make.leading.equalToSuperview().inset(20)
                make.centerY.equalToSuperview()
                make.size.equalTo(50)
            }
        
        lblTemperature
            .style(textColor: .systemBlue)
            .style(font: UIFont.boldSystemFont(ofSize: 28))
            .style(parentView: contentView)
            .style(contentHuggingPriority: .required, forAxis: .horizontal)
            .style(contentCompressionResistancePriority: .required, forAxis: .horizontal)
            .styleMakeConstraints { make in
                make.trailing.equalToSuperview().inset(20)
                make.centerY.equalToSuperview()
            }
        
        let vStack = UIStackView()
            .style(axis: .vertical)
            .style(spacing: 5)
            .style(parentView: contentView)
            .styleMakeConstraints { make in
                make.leading.equalToSuperview().inset(100)
                make.trailing.equalTo(lblTemperature.snp.leading).inset(10)
                make.centerY.equalToSuperview()
            }
        
        lblTime.style(parentView: vStack)
        lblDescription.style(parentView: vStack)
        
        fullLine.style(backgroundColor: .lightGray.withAlphaComponent(0.5))
            .style(parentView: self)
            .styleMakeConstraints { make in
                make.leading.bottom.trailing.equalToSuperview()
                make.height.equalTo(1)
            }
        
        shortLine.style(backgroundColor: .lightGray.withAlphaComponent(0.5))
            .style(parentView: self)
            .style(isHidden: true)
            .styleMakeConstraints { make in
                make.bottom.trailing.equalToSuperview()
                make.leading.equalToSuperview().inset(100)
                make.height.equalTo(1)
            }
    }
    
    func configure(model: ForecastViewModel, isLastRow: Bool) {
        imageViewWeather.style(image: model.icon)
        lblTemperature.style(text: model.temperature)
        lblTime.style(text: model.time)
        lblDescription.style(text: model.description)
        shortLine.style(isHidden: isLastRow)
        fullLine.style(isHidden: !isLastRow)
    }
}

private class TableViewHeader: UITableViewHeaderFooterView {
    
    private let lblTitle = UILabel()
    
    var title: String? {
        didSet {
            lblTitle.style(text: title)
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.backgroundColor = .white
        
        lblTitle.style(textColor: .gray)
            .style(backgroundColor: .white)
            .style(parentView: self)
            .styleMakeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(20)
                make.top.bottom.equalToSuperview()
            }
        
        UIView().style(backgroundColor: .lightGray.withAlphaComponent(0.5))
            .style(parentView: self)
            .styleMakeConstraints { make in
                make.leading.bottom.trailing.equalToSuperview()
                make.height.equalTo(1)
            }
    }
}
