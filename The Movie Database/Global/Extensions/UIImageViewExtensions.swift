//
//  UIImageViewExtensions.swift
//  The Movie Database
//
//  Created by Beavean on 09.08.2022.
//

import UIKit

extension UIImageView {
    
    //MARK: - Adds blur effect for background images
    
    func applyBlurEffect() {
        var blurEffect = UIBlurEffect()
        if self.traitCollection.userInterfaceStyle == .dark {
            blurEffect = UIBlurEffect(style: .dark)
        } else {
            blurEffect = UIBlurEffect(style: .light)
        }
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
        self.alpha = 0.6
    }
}
