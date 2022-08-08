//
//  DiscoverViewExtensions.swift
//  The Movie Database
//
//  Created by Beavean on 08.08.2022.
//

import UIKit

extension DiscoverViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nowPlayingMedia.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoverCollectionViewCell", for: indexPath) as? DiscoverCollectionViewCell
        let item = self.nowPlayingMedia[indexPath.row]
        cell!.configure(with: item)
        return cell!
    }
}
