//
//  UIButton+SavedImage.swift
//  The Movie Database
//
//  Created by Beavean on 09.08.2022.
//

import UIKit

extension UIButton {
    func changeImageIfSaved(condition: Bool) {
        let image = UIImage(systemName: condition ? Constants.UI.alreadySavedButtonImage : Constants.UI.saveButtonImage)
        setImage(image, for: .normal)
        tintColor = condition ? .orange : .label
    }
}
