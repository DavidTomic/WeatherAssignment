//
//  UIWindowExtension.swift
//  Weather
//
//  Created by David Tomić on 18.09.2021..
//

import UIKit

extension UIWindow {
    
    func topViewController() -> UIViewController? {
        var top = self.rootViewController
        while true {
            if let presented = top?.presentedViewController {
                top = presented
            } else if let navVC = top as? UINavigationController {
                top = navVC.visibleViewController
            } else if let tabVC = top as? UITabBarController {
                top = tabVC.selectedViewController
            } else {
                break
            }
        }
        return top
    }
}
