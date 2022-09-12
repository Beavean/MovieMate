//
//  UIView+CornerRadius.swift
//  The Movie Database
//
//  Created by Beavean on 09.08.2022.
//

import UIKit

extension UIView {
    
    //MARK: - Adds small corner radius based on height or width to images
    
    func addSmallCornerRadius() {
        self.layer.cornerRadius = self.frame.height < self.frame.width ? self.bounds.height * Constants.UI.cornerRadiusRatio : self.bounds.width * Constants.UI.cornerRadiusRatio
        self.clipsToBounds = true
        self.updateConstraints()
    }
}
