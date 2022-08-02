//
//  TableViewDelegate.swift
//  The Movie Database
//
//  Created by Beavean on 30.07.2022.
//

import UIKit

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: Constants.UI.DetailViewControllerID) as? DetailViewController, let mediaID = self.mediaSearchResults[indexPath.row].id {
            let media = self.mediaSearchResults[indexPath.row]
            viewController.media = media
            viewController.mediaID = mediaID
            viewController.loadView()
            viewController.mediaType = self.mediaType
            viewController.configureViewController(with: media)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
