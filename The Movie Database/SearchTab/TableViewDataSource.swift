//
//  TableViewDataSource.swift
//  The Movie Database
//
//  Created by Beavean on 30.07.2022.
//

import UIKit

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesSearchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: Constants.UI.MoviesCellReuseID, for: indexPath) as? MediaTableViewCell else { return UITableViewCell() }
        let item = moviesSearchResults[indexPath.row]
        cell.mediaType = self.mediaType
        cell.configure(with: item)
        return cell
    }
}
