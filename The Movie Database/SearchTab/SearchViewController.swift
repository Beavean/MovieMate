//
//  SearchViewController.swift
//  The Movie Database
//
//  Created by Beavean on 11.07.2022.
//

import UIKit
import SDWebImage
import Alamofire
import SwiftUI

class SearchViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var contentTypeSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var searchTableView: UITableView!
    
    var mediaType = Constants.Network.movieType
    var enteredQuery: String?
    var lastScheduledSearch: Timer?
    var moviesSearchResults = [MediaSearch.Results]()
    
    //MARK: - SearchViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchBar.delegate = self
        searchTableView.register(UINib(nibName: Constants.UI.MoviesCellReuseID, bundle: nil), forCellReuseIdentifier: Constants.UI.MoviesCellReuseID)
        receiveTrendingMedia()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.searchTableView.reloadData()
    }
    
    //MARK: - SearchViewController receives and shows trending media by default
    
    func receiveTrendingMedia() {
        let query = Constants.Network.trendingKey + mediaType + Constants.Network.dayKey + Constants.Network.apiKey
        NetworkManager.shared.makeRequest(query: query, model: MediaSearch?.self) { data in
            guard let mediaResults = data?.results else { return }
            self.moviesSearchResults = mediaResults
            self.searchTableView.reloadData()
        }
    }
    
    //MARK: - SearchBar interactions
    
    @objc func receiveSearchResults() {
        if searchBar.searchTextField.text == "" {
            receiveTrendingMedia()
        } else {
            if let enteredQuery = searchBar.searchTextField.text, let apiQuery = enteredQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
                let query = Constants.Network.mediaSearchKey + mediaType + Constants.Network.apiKey + Constants.Network.mediaSearchQueryKey + apiQuery
                NetworkManager.shared.makeRequest(query: query, model: MediaSearch?.self) { data in
                    guard let mediaResults = data?.results else { return }
                    self.moviesSearchResults = mediaResults
                    self.searchTableView.reloadData()
                }
                if searchTableView.numberOfRows(inSection: 0) > 0 {
                    searchTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
                } else {
                    return
                }
            }
        }
    }
    
    //MARK: - SegmentedControl interactions
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        switch contentTypeSegmentedControl.selectedSegmentIndex
        {
        case 0:
            mediaType = Constants.Network.movieType
            receiveSearchResults()
            searchBar.endEditing(true)
        case 1:
            mediaType = Constants.Network.tvSeriesType
            receiveSearchResults()
            searchBar.endEditing(true)
        default:
            receiveSearchResults()
            searchBar.endEditing(true)
        }
    }
}






