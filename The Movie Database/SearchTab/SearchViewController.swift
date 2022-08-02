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
    @IBOutlet private weak var mediaTableView: UITableView!
    
    var mediaType = Constants.Network.movieType
    var enteredQuery: String?
    var lastScheduledSearch: Timer?
    var mediaSearchResults = [MediaSearch.Results]()
    var viewModel = SearchViewModel()
    
    //MARK: - SearchViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mediaTableView.dataSource = self
        mediaTableView.delegate = self
        searchBar.delegate = self
        mediaTableView.register(UINib(nibName: Constants.UI.MoviesCellReuseID, bundle: nil), forCellReuseIdentifier: Constants.UI.MoviesCellReuseID)
        reloadMediaTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mediaTableView.reloadData()
    }
    
    //MARK: - SearchViewController receives and shows trending media by default
    
    func receiveTrendingMedia() {
        let query = Constants.Network.trendingKey + mediaType + Constants.Network.dayKey + Constants.Network.apiKey
        NetworkManager.shared.makeRequest(query: query, model: MediaSearch?.self) { data in
            guard let mediaResults = data?.results else { return }
            self.mediaSearchResults = mediaResults
            self.mediaTableView.reloadData()
        }
    }
    
    //MARK: - SegmentedControl interactions
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        viewModel.mediaTypeSegmentedControl =  contentTypeSegmentedControl.selectedSegmentIndex
        reloadMediaTableView()
    }
    
    @objc func reloadMediaTableView() {
        guard let enteredQuery = self.searchBar.searchTextField.text else { return }
        self.viewModel.enteredQuery = enteredQuery
        viewModel.receiveMedia {
            self.mediaType = self.viewModel.mediaType
            self.mediaSearchResults = self.viewModel.mediaSearchResults
            self.mediaTableView.reloadData()
        }
        if mediaTableView.numberOfRows(inSection: 0) > 0 {
            mediaTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
        } else {
            return
        }
    }
}







