//
//  ViewController.swift
//  The Movie Database
//
//  Created by Beavean on 11.07.2022.
//

import UIKit
import SDWebImage
import Alamofire

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchTableView: UITableView!
    
    let enteredQuery = "Star Wars"
    
    
    
    var moviesSearchResults = [MoviesSearch.Results]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTableView.dataSource = self
        searchTableView.delegate = self
        
        searchTableView.register(UINib(nibName: K.MoviesCellReuseID, bundle: nil), forCellReuseIdentifier: K.MoviesCellReuseID)
        
        let apiQuery = enteredQuery.replacingOccurrences(of: " ", with: "%20")
        let url = K.baseUrl + K.movieSearchKey + K.apiKey + K.movieSearchQuery + apiQuery
        print(url)
        AF.request(url).responseJSON { response in
            do {
                if let allData = try JSONDecoder().decode(MoviesSearch?.self, from: response.data!) {
                    self.moviesSearchResults = allData.results!
                    
                    print(self.moviesSearchResults.first!)
                    print(self.moviesSearchResults.count)
                    
                    DispatchQueue.main.async {
                        self.searchTableView.reloadData()
                    }
                }
            } catch {
                print(error)
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesSearchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: K.MoviesCellReuseID, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        print(moviesSearchResults.count)
        let item = moviesSearchResults[indexPath.row]
        cell.posterImageView.sd_setImage(with: URL(string: K.baseImageUrl + item.posterPath!))
        return cell
        
    }
}

extension SearchViewController: UITableViewDelegate {
    
}




