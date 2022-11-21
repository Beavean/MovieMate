//
//  SeriesViewExtensions.swift
//  The Movie Database
//
//  Created by Beavean on 09.08.2022.
//

import UIKit

extension SeriesViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var countOfItems = 0
        switch collectionView {
        case popularCollectionView: countOfItems = popularSeries.count
        case latestCollectionView: countOfItems = latestSeries.count
        case topRatedCollectionView: countOfItems = topRatedSeries.count
        default: return 0
        }
        return countOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.UI.discoverCollectionViewCellID, for: indexPath) as? DiscoverCollectionViewCell
        var item: BasicMedia.Results
        switch collectionView {
        case popularCollectionView: item = popularSeries[indexPath.row]
        case latestCollectionView: item = latestSeries[indexPath.row]
        case topRatedCollectionView: item = topRatedSeries[indexPath.row]
        default: return UICollectionViewCell()
        }
        guard let cell = cell else { return UICollectionViewCell() }
        cell.configure(with: item)
        return cell
    }
}

extension SeriesViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Constants.UI.mainStoryboardName, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: Constants.UI.detailViewControllerID) as? DetailViewController {
            var delegatingMediaID: Int
            switch collectionView {
            case popularCollectionView:
                guard let mediaID = popularSeries[indexPath.row].id else { return }
                delegatingMediaID = mediaID
            case latestCollectionView:
                guard let mediaID = latestSeries[indexPath.row].id else { return }
                delegatingMediaID = mediaID
            case topRatedCollectionView:
                guard let mediaID = topRatedSeries[indexPath.row].id else { return }
                delegatingMediaID = mediaID
            default: return
            }
            viewController.mediaID = delegatingMediaID
            viewController.mediaType = Constants.Network.tvSeriesType
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
