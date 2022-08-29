//
//  SavedViewController.swift
//  The Movie Database
//
//  Created by Beavean on 21.07.2022.
//

import UIKit
import RealmSwift

class SavedViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var savedMediaTableView: UITableView!
    @IBOutlet private weak var savedMediaSearchBar: UISearchBar!
    
    var arrayOfMedia: Results<RealmObjectModel>?
    private var lastScheduledSearch: Timer?
    private var viewModel: SavedViewModeling = SavedViewModel()
    
    //MARK: - SavedViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCompletions()
        viewModel.loadSavedMedia(searchText: self.savedMediaSearchBar.text)
        savedMediaTableView.dataSource = self
        savedMediaTableView.delegate = self
        savedMediaSearchBar.delegate = self
        savedMediaTableView.register(UINib(nibName: Constants.UI.mediaTableViewCellReuseID, bundle: nil), forCellReuseIdentifier: Constants.UI.mediaTableViewCellReuseID)
        savedMediaTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.loadSavedMedia(searchText: self.savedMediaSearchBar.text)
        savedMediaTableView.reloadData()
    }
    
    //MARK: - Model completion setup
    
    func setupCompletions() {
        viewModel.onDataUpdated = { [weak self] in
            guard let arrayOfMedia = self?.viewModel.arrayOfMedia else { return }
            self?.arrayOfMedia = arrayOfMedia
        }
    }
    
    //MARK: - SearchBar methods
    
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
        lastScheduledSearch = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { _ in
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


