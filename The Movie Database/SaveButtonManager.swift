//
//  SaveButtonManager.swift
//  The Movie Database
//
//  Created by Beavean on 30.07.2022.
//

import UIKit

struct SaveButtonManager {
    func savePressed(sender: UIButton, viewController: UIViewController, mediaID: Int?, mediaType: String?, media: MediaSearch.Results?) {
        
        guard let mediaID = mediaID, let media = media, let mediaType = mediaType else { return }
        
        if RealmDataManager.shared.checkIfAlreadySaved(id: mediaID) {
            let alert = UIAlertController(title: "Already saved", message: "Do you want to remove it?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default)
            let deleteAction = UIAlertAction(title: "Remove", style: .default) { action in
                RealmDataManager.shared.deleteMedia(id: mediaID)
            }
            alert.view.tintColor = UIColor.label
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            viewController.present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Save it?", message: "This will add the item to the saved list", preferredStyle: .alert)
            let saveAction = UIAlertAction(title: "Save", style: .default) { action in
                RealmDataManager.shared.saveMedia(from: media, mediaType: mediaType)
                sender.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                sender.setTitle("", for: .normal)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default)
            alert.view.tintColor = UIColor.label
            alert.addAction(cancelAction)
            alert.addAction(saveAction)
            viewController.present(alert, animated: true)
        }
    }
}
