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
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchTableView: UITableView!
    
    var mediaType = "movie"
    var enteredQuery = ""
    var lastScheduledSearch: Timer?
    
    var moviesSearchResults = [MoviesSearch.Results]()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchBar.delegate = self
        
        searchTableView.register(UINib(nibName: K.MoviesCellReuseID, bundle: nil), forCellReuseIdentifier: K.MoviesCellReuseID)
        
        receiveTrendingMedia()
        
    }
    
    func receiveTrendingMedia() {
        let url = K.baseUrl + K.trendingKey + mediaType + K.dayKey + K.apiKey
        AF.request(url).responseData { response in
            do {
                if let receivedData = response.data, let allData = try JSONDecoder().decode(MoviesSearch?.self, from: receivedData) {
                    self.moviesSearchResults = allData.results ?? []
                    DispatchQueue.main.async {
                        self.searchTableView.reloadData()
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    @objc func receiveSearchResults() {
        if searchBar.searchTextField.text == "" {
            receiveTrendingMedia()
            return
        } else {
            enteredQuery = searchBar.searchTextField.text!
            if let apiQuery = enteredQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
                let url = K.baseUrl + K.mediaSearchKey + mediaType + K.apiKey + K.mediaSearchQueryKey + apiQuery
                AF.request(url).responseData { response in
                    do {
                        if let receivedData = response.data, let allData = try JSONDecoder().decode(MoviesSearch?.self, from: receivedData)  {
                            self.moviesSearchResults = allData.results ?? []
                            DispatchQueue.main.async {
                                self.searchTableView.reloadData()
                            }
                        }
                    } catch {
                        print(error)
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
    
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            mediaType = "movie"
            receiveSearchResults()
            searchBar.endEditing(true)
        case 1:
            mediaType = "tv"
            receiveSearchResults()
            searchBar.endEditing(true)
        default:
            searchBar.endEditing(true)
            receiveSearchResults()
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesSearchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: K.MoviesCellReuseID, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        let item = moviesSearchResults[indexPath.row]
        cell.configure(withModel: item)
        return cell
        
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: K.DetailViewControllerID) as? DetailViewController {
            let media = self.moviesSearchResults[indexPath.row]
            viewController.media = media
            viewController.mediaID = self.moviesSearchResults[indexPath.row].id!
            viewController.loadView()
            viewController.configureViewController(with: media)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

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






