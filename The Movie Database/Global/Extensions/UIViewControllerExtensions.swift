//
//  UIViewControllerExtensions.swift
//  The Movie Database
//
//  Created by Beavean on 09.08.2022.
//

import UIKit

extension UIViewController {
    
    //MARK: - Save button processing & alert display methods
    
    func saveButtonPressed(button: UIButton, mediaID: Int?, mediaType: String?, completion: @escaping ()->()) {
        guard let mediaID = mediaID else { return }
        if RealmObjectManager.shared.checkIfAlreadySaved(id: mediaID) {
            let alert = UIAlertController(title: "Already saved", message: "Do you want to remove it?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default)
            let deleteAction = UIAlertAction(title: "Remove", style: .default) { action in
                RealmObjectManager.shared.deleteMedia(id: mediaID)
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
                    RealmObjectManager.shared.saveMedia(from: details, mediaType: mediaType)
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