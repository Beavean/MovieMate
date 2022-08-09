//
//  MoviesViewExtensions.swift
//  The Movie Database
//
//  Created by Beavean on 08.08.2022.
//

import UIKit

extension MoviesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var countOfItems = 0
        switch collectionView {
        case nowPlayingCollectionView: countOfItems = nowPlayingMovies.count
        case upcomingCollectionView: countOfItems = upcomingMovies.count
        case topRatedCollectionView: countOfItems = topRatedMovies.count
        default: return 0
        }
        return countOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.UI.discoverCollectionViewCellID, for: indexPath) as? DiscoverCollectionViewCell
        var item: BasicMedia.Results
        switch collectionView {
        case nowPlayingCollectionView: item = nowPlayingMovies[indexPath.row]
        case upcomingCollectionView: item = upcomingMovies[indexPath.row]
        case topRatedCollectionView: item = topRatedMovies[indexPath.row]
        default: return UICollectionViewCell()
        }
        guard let cell = cell else { return UICollectionViewCell() }
        cell.configure(with: item)
        return cell
    }
}

extension MoviesViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Constants.UI.mainStoryboardName, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: Constants.UI.detailViewControllerID) as? DetailViewController {
            var delegatingMediaID: Int
            switch collectionView {
            case nowPlayingCollectionView:
                guard let mediaID = nowPlayingMovies[indexPath.row].id else { return }
                delegatingMediaID = mediaID
            case upcomingCollectionView:
                guard let mediaID = upcomingMovies[indexPath.row].id else { return }
                delegatingMediaID = mediaID
            case topRatedCollectionView:
                guard let mediaID = topRatedMovies[indexPath.row].id else { return }
                delegatingMediaID = mediaID
            default: return
            }
            viewController.mediaID = delegatingMediaID
            viewController.mediaType = Constants.Network.movieType
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
