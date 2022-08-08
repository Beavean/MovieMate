//
//  DiscoverViewController.swift
//  The Movie Database
//
//  Created by Beavean on 08.08.2022.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    @IBOutlet weak var nowPlayingCollectionView: UICollectionView!
    @IBOutlet weak var upcomingCollectionView: UICollectionView!
    @IBOutlet weak var topRatedCollectionView: UICollectionView!
    
    var viewModel: DiscoverViewModeling = DiscoverViewModel()
    var nowPlayingMedia = [MediaSearch.Results]()
    var upcomingMedia = [MediaSearch.Results]()
    var topRatedMedia = [MediaSearch.Results]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCompletions()
        viewModel.updateData()
        nowPlayingCollectionView.dataSource = self
        upcomingCollectionView.dataSource = self
        topRatedCollectionView.dataSource = self
        self.nowPlayingCollectionView.register(UINib(nibName: Constants.UI.discoverCollectionViewCellID, bundle: nil), forCellWithReuseIdentifier: Constants.UI.discoverCollectionViewCellID)
        self.upcomingCollectionView.register(UINib(nibName: Constants.UI.discoverCollectionViewCellID, bundle: nil), forCellWithReuseIdentifier: Constants.UI.discoverCollectionViewCellID)
        self.topRatedCollectionView.register(UINib(nibName: Constants.UI.discoverCollectionViewCellID, bundle: nil), forCellWithReuseIdentifier: Constants.UI.discoverCollectionViewCellID)
    }
    
    override func viewWillLayoutSubviews() {
        nowPlayingCollectionView.reloadData()
        upcomingCollectionView.reloadData()
        topRatedCollectionView.reloadData()
        nowPlayingCollectionView.layoutIfNeeded()
        upcomingCollectionView.layoutIfNeeded()
        topRatedCollectionView.layoutIfNeeded()
    }
    
    func setupCompletions() {
        viewModel.onDataUpdated = { [weak self] in
            guard let nowPlayingMedia = self?.viewModel.nowPlayingMedia,
                  let upcomingMedia = self?.viewModel.upcomingMedia,
                  let topRatedMedia = self?.viewModel.topRatedMedia
            else { return }
            self?.nowPlayingMedia = nowPlayingMedia
            self?.upcomingMedia = upcomingMedia
            self?.topRatedMedia = topRatedMedia
            self?.nowPlayingCollectionView.reloadData()
            self?.upcomingCollectionView.reloadData()
            self?.topRatedCollectionView.reloadData()
            self?.nowPlayingCollectionView.layoutIfNeeded()
            self?.upcomingCollectionView.layoutIfNeeded()
            self?.topRatedCollectionView.layoutIfNeeded()
        }
    }
}
