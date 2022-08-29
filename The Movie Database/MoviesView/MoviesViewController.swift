//
//  MoviesViewController.swift
//  The Movie Database
//
//  Created by Beavean on 08.08.2022.
//

import UIKit

class MoviesViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var nowPlayingCollectionView: UICollectionView!
    @IBOutlet weak var upcomingCollectionView: UICollectionView!
    @IBOutlet weak var topRatedCollectionView: UICollectionView!
    
    //MARK: - Variables
    
    var nowPlayingMovies = [BasicMedia.Results]()
    var upcomingMovies = [BasicMedia.Results]()
    var topRatedMovies = [BasicMedia.Results]()
    private var viewModel: MoviesViewModeling = MoviesViewModel()
    
    //MARK: - Discover View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCompletions()
        viewModel.updateData()
        nowPlayingCollectionView.dataSource = self
        upcomingCollectionView.dataSource = self
        topRatedCollectionView.dataSource = self
        nowPlayingCollectionView.delegate = self
        upcomingCollectionView.delegate = self
        topRatedCollectionView.delegate = self
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
    
    //MARK: - Completions to run after model receives data
    
    func setupCompletions() {
        viewModel.onDataUpdated = { [weak self] in
            guard let nowPlayingMovies = self?.viewModel.nowPlayingMovies,
                  let upcomingMovies = self?.viewModel.upcomingMovies,
                  let topRatedMovies = self?.viewModel.topRatedMovies
            else { return }
            self?.nowPlayingMovies = nowPlayingMovies
            self?.upcomingMovies = upcomingMovies
            self?.topRatedMovies = topRatedMovies
            self?.nowPlayingCollectionView.reloadData()
            self?.upcomingCollectionView.reloadData()
            self?.topRatedCollectionView.reloadData()
            self?.nowPlayingCollectionView.layoutIfNeeded()
            self?.upcomingCollectionView.layoutIfNeeded()
            self?.topRatedCollectionView.layoutIfNeeded()
        }
    }
}
