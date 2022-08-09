//
//  DiscoverViewExtensions.swift
//  The Movie Database
//
//  Created by Beavean on 08.08.2022.
//

import UIKit

extension DiscoverViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var countOfItems = 0
        switch collectionView {
        case nowPlayingCollectionView: countOfItems = nowPlayingMedia.count
        case upcomingCollectionView: countOfItems = upcomingMedia.count
        case topRatedCollectionView: countOfItems = topRatedMedia.count
        default: return 0
        }
        return countOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.UI.discoverCollectionViewCellID, for: indexPath) as? DiscoverCollectionViewCell
        var item: MediaSearch.Results
        switch collectionView {
        case nowPlayingCollectionView: item = nowPlayingMedia[indexPath.row]
        case upcomingCollectionView: item = upcomingMedia[indexPath.row]
        case topRatedCollectionView: item = topRatedMedia[indexPath.row]
        default: return UICollectionViewCell()
        }
        cell!.configure(with: item)
        return cell!
    }
}

extension DiscoverViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Constants.UI.mainStoryboardName, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: Constants.UI.detailViewControllerID) as? DetailViewController {
            var delegatingMediaID: Int
            switch collectionView {
            case nowPlayingCollectionView:
                guard let mediaID = nowPlayingMedia[indexPath.row].id else { return }
                delegatingMediaID = mediaID
            case upcomingCollectionView:
                guard let mediaID = upcomingMedia[indexPath.row].id else { return }
                delegatingMediaID = mediaID
            case topRatedCollectionView:
                guard let mediaID = topRatedMedia[indexPath.row].id else { return }
                delegatingMediaID = mediaID
            default: return
            }
            viewController.mediaID = delegatingMediaID
            viewController.mediaType = Constants.Network.movieType
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
