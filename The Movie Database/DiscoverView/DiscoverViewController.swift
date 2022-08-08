//
//  DiscoverViewController.swift
//  The Movie Database
//
//  Created by Beavean on 08.08.2022.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    @IBOutlet weak var discoverCollectionView: UICollectionView!
    
    var viewModel: DiscoverViewModeling = DiscoverViewModel()
    var nowPlayingMedia = [MediaSearch.Results]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCompletions()
        viewModel.updateData()
        self.discoverCollectionView.register(UINib(nibName: "DiscoverCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DiscoverCollectionViewCell")
    }
    
    override func viewWillLayoutSubviews() {
        discoverCollectionView.reloadData()
        discoverCollectionView.layoutIfNeeded()
    }
    
    func setupCompletions() {
        viewModel.onDataUpdated = { [weak self] in
            guard let receivedMedia = self?.viewModel.nowPlayingMedia else { return }
            self?.nowPlayingMedia = receivedMedia
            self?.discoverCollectionView.reloadData()
            self?.discoverCollectionView.layoutIfNeeded()
        }
    }
}
