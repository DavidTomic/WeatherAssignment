//
//  AnimatedImageView.swift
//  Weather
//
//  Created by David Tomić on 19.09.2021..
//

import UIKit

class AnimatedImageView: UIImageView {
    
    override var image: UIImage? {
        didSet {
            super.image = image
            startAnimation()
        }
    }
    
    private func startAnimation() {
        let shakeValues = [-5, 5, -5, 5, -3, 3, -2, 2, 0]
        
        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        translation.timingFunction = CAMediaTimingFunction(name: .linear)
        translation.values = shakeValues
        
        let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotation.values = shakeValues.map { (Int(Double.pi) * $0) / 180 }
        
        let shakeGroup = CAAnimationGroup()
        shakeGroup.animations = [translation, rotation]
        shakeGroup.duration = 1.0
        layer.add(shakeGroup, forKey: "shakeIt")
    }
}
