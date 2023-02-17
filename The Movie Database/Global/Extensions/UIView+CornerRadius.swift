//
//  UIView+CornerRadius.swift
//  The Movie Database
//
//  Created by Beavean on 09.08.2022.
//

import UIKit

extension UIView {
    func addSmallCornerRadius() {
        let cornerRadius = min(self.bounds.width, self.bounds.height) * Constants.UI.cornerRadiusRatio
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.updateConstraints()
    }
}
