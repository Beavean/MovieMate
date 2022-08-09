//
//  UIViewExtensions.swift
//  The Movie Database
//
//  Created by Beavean on 09.08.2022.
//

import UIKit

extension UIView {
    
    //MARK: - Adds small corner radius based on height or width to images
    
    func addSmallCornerRadius() {
        if self.frame.height < self.frame.width {
            self.layer.cornerRadius = self.bounds.height * Constants.UI.cornerRadiusRatio
        } else {
            self.layer.cornerRadius = self.bounds.width * Constants.UI.cornerRadiusRatio
        }
        self.updateConstraints()
    }
}
