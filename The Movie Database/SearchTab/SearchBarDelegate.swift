//
//  SearchBarDelegate.swift
//  The Movie Database
//
//  Created by Beavean on 30.07.2022.
//

import UIKit

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        receiveSearchResults()
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        receiveSearchResults()
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        lastScheduledSearch?.invalidate()
        lastScheduledSearch = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(receiveSearchResults), userInfo: nil, repeats: false)
    }
}
