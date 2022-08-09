//
//  Extensions.swift
//  The Movie Database
//
//  Created by Beavean on 03.08.2022.
//

import UIKit

extension UIImageView {
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

extension UIView {
    func addSmallCornerRadius() {
        if self.frame.height < self.frame.width {
            self.layer.cornerRadius = self.bounds.height * Constants.UI.cornerRadiusRatio
        } else {
            self.layer.cornerRadius = self.bounds.width * Constants.UI.cornerRadiusRatio
        }
        self.updateConstraints()
    }
}

extension UIButton {
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

extension UIViewController {
    func saveButtonPressed(button: UIButton, mediaID: Int?, mediaType: String?, completion: @escaping ()->()) {
        guard let mediaID = mediaID else { return }
        if RealmManager.shared.checkIfAlreadySaved(id: mediaID) {
            let alert = UIAlertController(title: "Already saved", message: "Do you want to remove it?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default)
            let deleteAction = UIAlertAction(title: "Remove", style: .default) { action in
                RealmManager.shared.deleteMedia(id: mediaID)
                completion()
            }
            alert.view.tintColor = UIColor.label
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Save it?", message: "This will add the item to the saved list", preferredStyle: .alert)
            let saveAction = UIAlertAction(title: "Save", style: .default) { action in
                guard let mediaType = mediaType else { return }
                NetworkManager.shared.getMediaDetails(mediaID: mediaID, mediaType: mediaType) { details in
                    RealmManager.shared.saveMedia(from: details, mediaType: mediaType)
                }
                button.changeImageIfSaved(condition: true)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default)
            alert.view.tintColor = UIColor.label
            alert.addAction(cancelAction)
            alert.addAction(saveAction)
            present(alert, animated: true)
        }
    }
}
