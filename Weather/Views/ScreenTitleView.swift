//
//  ScreenTitleView.swift
//  Weather
//
//  Created by David Tomić on 18.09.2021..
//

import UIKit

class ScreenTitleView: UIView {
    
    private enum Constants {
        static let viewHeight = 50
        static let lineHeight = 1
    }
    
    private let lblTitle = UILabel()
    
    var title: String? {
        didSet {
            lblTitle.style(text: title)
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
        styleMakeConstraints { make in
            make.height.equalTo(Constants.viewHeight).priority(.low)
        }
        
        lblTitle.style(parentView: self)
            .styleMakeConstraints { make in
                make.center.equalToSuperview()
            }
        
        UIView().style(backgroundColor: .systemBlue)
            .style(parentView: self)
            .styleMakeConstraints { make in
                make.leading.bottom.trailing.equalToSuperview()
                make.height.equalTo(Constants.lineHeight)
            }
    }
}
