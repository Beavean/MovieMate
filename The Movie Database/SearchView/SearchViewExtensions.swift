//
//  SearchViewExtensions.swift
//  The Movie Database
//
//  Created by Beavean on 30.07.2022.
//

import UIKit

extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Constants.UI.mainStoryboardName, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: Constants.UI.detailViewControllerID) as? DetailViewController, let mediaID = self.mediaSearchResults[indexPath.row].id {
            viewController.mediaID = mediaID
            viewController.mediaType = self.mediaType
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaSearchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: Constants.UI.mediaTableViewCellReuseID, for: indexPath) as? MediaTableViewCell else { return UITableViewCell() }
        let item = mediaSearchResults[indexPath.row]
        cell.saveButtonCompletion = { aCell in
            self.saveButtonPressed(button: cell.saveButton, mediaID: item.id, mediaType: self.mediaType) { [weak self] in
                self?.mediaTableView.reloadData()
            }
        }
        cell.videoButtonCompletion = { [weak self] in
            if let viewController = self?.storyboard?.instantiateViewController(withIdentifier: Constants.UI.videoViewControllerID) as? VideoViewController {
                viewController.configureTitle(title: item.originalTitle ?? item.originalName)
                viewController.mediaID = item.id
                viewController.mediaType = self?.mediaType
                self?.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        cell.mediaType = self.mediaType
        cell.receivedMedia = item
        cell.selectionStyle = .none
        return cell
    }
}
