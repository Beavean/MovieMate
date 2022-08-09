//
//  UIButtonExtensions.swift
//  The Movie Database
//
//  Created by Beavean on 09.08.2022.
//

import UIKit

extension UIButton {
    
    //MARK: - Save button image and colour changes
    
    func changeImageIfSaved(condition: Bool) {
        if condition {
            self.setImage(UIImage(systemName: Constants.UI.alreadySavedButtonImage), for: .normal)
            self.tintColor = .orange
        } else {
            self.setImage(UIImage(systemName: Constants.UI.saveButtonImage), for: .normal)
            self.tintColor = .label
        }
    }
}
