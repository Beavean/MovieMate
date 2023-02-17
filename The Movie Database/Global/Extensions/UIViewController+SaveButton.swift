//
//  UIViewController+SaveButton.swift
//  The Movie Database
//
//  Created by Beavean on 09.08.2022.
//

import UIKit

extension UIViewController {
    func saveButtonPressed(button: UIButton, mediaID: Int?, mediaType: String?, completion: (() -> Void)? = nil) {
        guard let mediaID = mediaID else { return }
        let isMediaSaved = RealmObjectManager.shared.checkIfAlreadySaved(id: mediaID)
        let alertTitle = isMediaSaved ? "Remove from saved?" : "Add to saved?"
        let saveActionTitle = isMediaSaved ? "Remove" : "Save"
        let alertController = UIAlertController(title: alertTitle, message: "", preferredStyle: .alert)
        alertController.view.tintColor = UIColor.label
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alertController.addAction(cancelAction)
        let saveAction = UIAlertAction(title: saveActionTitle, style: .default) { _ in
            guard let mediaType else { return }
            if isMediaSaved {
                RealmObjectManager.shared.deleteMedia(id: mediaID)
                button.changeImageIfSaved(condition: false)
            } else {
                NetworkManager.shared.getMediaDetails(mediaID: mediaID, mediaType: mediaType) { details in
                    RealmObjectManager.shared.saveMedia(from: details, mediaType: mediaType)
                    button.changeImageIfSaved(condition: true)
                }
            }
            completion?()
        }
        alertController.addAction(saveAction)
        self.present(alertController, animated: true)
    }
}
