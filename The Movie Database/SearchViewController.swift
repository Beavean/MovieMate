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
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
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
    
    //MARK: - SearchViewController receives and shows trending media by default
    
    func receiveTrendingMedia() {
        guard let url = URL(string: Constants.Network.baseUrl + Constants.Network.trendingKey + mediaType + Constants.Network.dayKey + Constants.Network.apiKey) else { return }
        AF.request(url).responseData { response in
            do {
                if let receivedData = response.data, let allData = try JSONDecoder().decode(MediaSearch?.self, from: receivedData) {
                    self.moviesSearchResults = allData.results ?? []
                    DispatchQueue.main.async {
                        self.searchTableView.reloadData()
                    }
                }
            } catch {
                print("Error loading trending media: \(error)")
            }
        }
    }
    
    //MARK: - SearchBar interactions
    
    @objc func receiveSearchResults() {
        if searchBar.searchTextField.text == "" {
            receiveTrendingMedia()
            return
        } else {
            if let enteredQuery = searchBar.searchTextField.text, let apiQuery = enteredQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
                guard let url = URL(string: Constants.Network.baseUrl + Constants.Network.mediaSearchKey + mediaType + Constants.Network.apiKey + Constants.Network.mediaSearchQueryKey + apiQuery) else { return }
                AF.request(url).responseData { response in
                    do {
                        if let receivedData = response.data, let allData = try JSONDecoder().decode(MediaSearch?.self, from: receivedData)  {
                            self.moviesSearchResults = allData.results ?? []
                            DispatchQueue.main.async {
                                self.searchTableView.reloadData()
                            }
                        }
                    } catch {
                        print("Error loading search results: \(error)")
                    }
                }
                self.searchTableView.reloadData()
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
        switch segmentedControl.selectedSegmentIndex
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
            searchBar.endEditing(true)
            receiveSearchResults()
        }
    }
}

//MARK: - TableView DataSource extension

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesSearchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: Constants.UI.MoviesCellReuseID, for: indexPath) as? MediaTableViewCell else { return UITableViewCell() }
        let item = moviesSearchResults[indexPath.row]
        cell.configure(with: item)
        return cell
        
    }
}

//MARK: - TableView Delegate extension

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: Constants.UI.DetailViewControllerID) as? DetailViewController, let mediaID = self.moviesSearchResults[indexPath.row].id {
            let media = self.moviesSearchResults[indexPath.row]
            viewController.media = media
            viewController.mediaID = mediaID
            viewController.loadView()
            viewController.mediaType = self.mediaType
            viewController.configureViewController(with: media)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

//MARK: - SearchBar Delegate extension

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






