//
//  MoviesViewController.swift
//  The Movie Database
//
//  Created by Beavean on 08.08.2022.
//

import UIKit

final class MoviesViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var nowPlayingCollectionView: UICollectionView!
    @IBOutlet weak var upcomingCollectionView: UICollectionView!
    @IBOutlet weak var topRatedCollectionView: UICollectionView!
    
    //MARK: - Variables
    
    var nowPlayingMovies = [BasicMedia.Results]()  {
        didSet { nowPlayingCollectionView.reloadData() }
    }
    
    var upcomingMovies = [BasicMedia.Results]() {
        didSet { upcomingCollectionView.reloadData() }
    }
    
    var topRatedMovies = [BasicMedia.Results]() {
        didSet { topRatedCollectionView.reloadData() }
    }
    
    private var viewModel: MoviesViewModeling = MoviesViewModel()
    
    //MARK: - Discover View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCompletions()
        viewModel.updateData()
        setupCollectionView(nowPlayingCollectionView)
        setupCollectionView(upcomingCollectionView)
        setupCollectionView(topRatedCollectionView)
    }
    
    //MARK: - Completions to run after model receives data
    
    private func setupCompletions() {
        showLoader(true)
        viewModel.onDataUpdated = { [weak self] in
            guard let nowPlayingMovies = self?.viewModel.nowPlayingMovies,
                  let upcomingMovies = self?.viewModel.upcomingMovies,
                  let topRatedMovies = self?.viewModel.topRatedMovies
            else { return }
            self?.nowPlayingMovies = nowPlayingMovies
            self?.upcomingMovies = upcomingMovies
            self?.topRatedMovies = topRatedMovies
            self?.showLoader(false)
        }
    }
    
    //MARK: - Collection View setups
    
    private func setupCollectionView(_ collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: Constants.UI.discoverCollectionViewCellID, bundle: nil), forCellWithReuseIdentifier: Constants.UI.discoverCollectionViewCellID)
    }
}
