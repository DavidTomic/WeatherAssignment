//
//  UIAlertControllerExtension.swift
//  Weather
//
//  Created by David Tomić on 18.09.2021..
//

import UIKit

extension UIAlertController {
    
    func show() {
        if let topViewController = UIApplication.shared.windows.first?.topViewController() {
            topViewController.present(self, animated: true, completion: nil)
        }
    }
}
