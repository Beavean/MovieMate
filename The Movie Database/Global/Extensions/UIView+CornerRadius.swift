//
//  UIView+CornerRadius.swift
//  The Movie Database
//
//  Created by Beavean on 09.08.2022.
//

import UIKit

extension UIView {
    func addSmallCornerRadius() {
        let cornerRadius = min(bounds.width, bounds.height) * Constants.UI.cornerRadiusRatio
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        updateConstraints()
    }
}
