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
            self.saveButtonPressed(button: cell.saveButton, mediaID: item.id, mediaType: self.mediaType) {
                tableView.reloadData()
            }
        }
        cell.videoButtonCompletion = {
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.UI.videoViewControllerID) as? VideoViewController {
                viewController.configureTitle(title: item.originalTitle ?? item.originalName)
                viewController.mediaID = item.id
                viewController.mediaType = self.mediaType
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        cell.mediaType = self.mediaType
        cell.configure(with: item)
        cell.selectionStyle = .none
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadSearchResults()
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadSearchResults()
        searchBar.text = ""
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        lastScheduledSearch?.invalidate()
        lastScheduledSearch = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(loadSearchResults), userInfo: nil, repeats: false)
    }
}
