//
//  SavedViewExtensions.swift
//  The Movie Database
//
//  Created by Beavean on 03.08.2022.
//

import UIKit

extension SavedViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Constants.UI.mainStoryboardName, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: Constants.UI.detailViewControllerID) as? DetailViewController, let media = self.arrayOfMedia?[indexPath.row] {
            viewController.mediaID = media.id
            viewController.mediaType = media.mediaType
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayOfMedia?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let media = self.arrayOfMedia?[indexPath.row] else { return }
        if editingStyle == .delete {
            RealmObjectManager.shared.deleteMedia(id: media.id)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else { 
            return
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: Constants.UI.mediaTableViewCellReuseID, for: indexPath) as? MediaTableViewCell, let item = self.arrayOfMedia?[indexPath.row] else {  return UITableViewCell() }
        cell.configure(with: item)
        cell.selectionStyle = .none
        cell.saveButtonCompletion = { aCell in
            let actualIndexPath = tableView.indexPath(for: aCell)!
            self.saveButtonPressed(button: cell.saveButton, mediaID: item.id, mediaType: item.mediaType) {
                tableView.deleteRows(at: [actualIndexPath], with: .fade)
            }
        }
        cell.videoButtonCompletion = { [weak self] in
            if let viewController = self?.storyboard?.instantiateViewController(withIdentifier: Constants.UI.videoViewControllerID) as? VideoViewController {
                viewController.configureTitle(title: item.originalTitle)
                viewController.mediaID = item.id
                viewController.mediaType = item.mediaType
                self?.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        return cell
    }
}
