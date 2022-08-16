//
//  SavedViewExtensions.swift
//  The Movie Database
//
//  Created by Beavean on 03.08.2022.
//

import UIKit
import SwiftUI

extension SavedViewController: UITableViewDelegate, UITableViewDataSource {
    
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
            savedMediaTableView.reloadData()
        } else {
            return
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: Constants.UI.mediaTableViewCellReuseID, for: indexPath) as? MediaTableViewCell, let item = self.arrayOfMedia?[indexPath.row] else {  return UITableViewCell() }
        cell.saveButtonCompletion = {
            self.saveButtonPressed(button: cell.saveButton, mediaID: item.id, mediaType: item.mediaType) {
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.savedMediaTableView.reloadData()
            }
        }
        cell.videoButtonCompletion = {
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.UI.videoViewControllerID) as? VideoViewController {
                viewController.mediaID = item.id
                viewController.mediaType = item.mediaType
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        cell.configure(with: item)
        cell.selectionStyle = .none
        return cell
    }
}

extension SavedViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        self.viewModel.loadSavedMedia(searchText: self.savedMediaSearchBar.text)
        self.savedMediaTableView.reloadData()
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        lastScheduledSearch?.invalidate()
        lastScheduledSearch = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { Timer in
            self.viewModel.loadSavedMedia(searchText: self.savedMediaSearchBar.text)
            self.lastScheduledSearch?.invalidate()
            self.savedMediaTableView.reloadData()
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.loadSavedMedia(searchText: self.savedMediaSearchBar.text)
        self.savedMediaTableView.reloadData()
        searchBar.text = ""
        searchBar.endEditing(true)
    }
}
