//
//  SearchViewController.swift
//  The Movie Database
//
//  Created by Beavean on 11.07.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var contentTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var mediaTableView: UITableView!
    
    //MARK: - Variables
    
    var mediaSearchResults = [BasicMedia.Results]() {
        didSet { mediaTableView.reloadData() }
    }
    
    var mediaType = Constants.Network.movieType
    private var lastScheduledSearch: Timer?
    private var enteredQuery: String?
    private var viewModel: SearchViewModeling = SearchViewModel()
    
    //MARK: - SearchViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCompletions()
        viewModel.updateData()
        mediaTableView.dataSource = self
        mediaTableView.delegate = self
        searchBar.delegate = self
        mediaTableView.register(UINib(nibName: Constants.UI.mediaTableViewCellReuseID, bundle: nil), forCellReuseIdentifier: Constants.UI.mediaTableViewCellReuseID)
    }
    
    //MARK: - SegmentedControl interaction and reload media methods
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        viewModel.mediaTypeSegmentedControl = contentTypeSegmentedControl.selectedSegmentIndex
        loadSearchResults()
    }
    
    @objc func loadSearchResults() {
        guard let enteredQuery = self.searchBar.searchTextField.text else { return }
        self.viewModel.enteredQuery = enteredQuery
        viewModel.updateData()
    }
    
    private func setupCompletions() {
        showLoader(true)
        viewModel.onDataUpdated = { [weak self] in
            guard let receivedMedia = self?.viewModel.mediaSearchResults,
                  let mediaType = self?.viewModel.mediaType,
                  let mediaTableView = self?.mediaTableView else { return }
            self?.mediaSearchResults = receivedMedia
            self?.mediaType = mediaType
            if mediaTableView.numberOfRows(inSection: 0) > 0 {
                mediaTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
            } else {
                return
            }
            self?.showLoader(false)
        }
    }
    
    //MARK: - SearchBar methods
    
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







