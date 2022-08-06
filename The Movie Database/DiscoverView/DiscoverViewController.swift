//
//  DiscoverViewController.swift
//  The Movie Database
//
//  Created by Beavean on 06.08.2022.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    @IBOutlet weak var discoverCollectionView: UICollectionView!
    
    var viewModel = DiscoverViewModel()
    var nowPlayingMedia = [MediaSearch.Results]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.receiveNowPlayingMedia {
            self.discoverCollectionView.register(UINib(nibName: "DiscoverCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DiscoverCollectionViewCell")
            self.discoverCollectionView.reloadData()
        }
    }
}



extension DiscoverViewController: UICollectionViewDelegate {
    
}

extension DiscoverViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.receiveNowPlayingMedia {
            self.nowPlayingMedia = self.viewModel.nowPlayingMedia
        }
        return viewModel.nowPlayingMedia.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoverCollectionViewCell", for: indexPath) as? DiscoverCollectionViewCell
        let item = viewModel.nowPlayingMedia[indexPath.row]
        cell!.configure(with: item)
        return cell!
    }
}

