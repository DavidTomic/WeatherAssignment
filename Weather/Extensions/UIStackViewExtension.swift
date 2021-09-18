//
//  UIStackViewExtension.swift
//  Weather
//
//  Created by David Tomić on 18.09.2021..
//

import UIKit

extension UIStackView {
    
    func clearArrangedSubviews() {
        for view in self.arrangedSubviews {
            view.removeFromSuperview()
        }
    }
}
