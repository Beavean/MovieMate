//
//  SeriesViewController.swift
//  The Movie Database
//
//  Created by Beavean on 09.08.2022.
//

import UIKit

class SeriesViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var popularCollectionView: UICollectionView!
    @IBOutlet weak var latestCollectionView: UICollectionView!
    @IBOutlet weak var topRatedCollectionView: UICollectionView!
    
    //MARK: - Variables
    
    var popularSeries = [BasicMedia.Results]()
    var latestSeries = [BasicMedia.Results]()
    var topRatedSeries = [BasicMedia.Results]()
    private var viewModel: SeriesViewModeling = SeriesViewModel()
    
    //MARK: - Discover View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCompletions()
        viewModel.updateData()
        setupCollectionView(popularCollectionView)
        setupCollectionView(latestCollectionView)
        setupCollectionView(topRatedCollectionView)
    }
    
    //MARK: - Completions to run the code after model receives data
    
    func setupCompletions() {
        viewModel.onDataUpdated = { [weak self] in
            guard let popularSeries = self?.viewModel.popularSeries,
                  let latestSeries = self?.viewModel.latestSeries,
                  let topRatedSeries = self?.viewModel.topRatedSeries
            else { return }
            self?.popularSeries = popularSeries
            self?.latestSeries = latestSeries
            self?.topRatedSeries = topRatedSeries
            self?.reloadCollectionView(self?.popularCollectionView)
            self?.reloadCollectionView(self?.latestCollectionView)
            self?.reloadCollectionView(self?.topRatedCollectionView)
        }
    }
    //MARK: - Collection View setups
    
    func setupCollectionView(_ collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: Constants.UI.discoverCollectionViewCellID, bundle: nil), forCellWithReuseIdentifier: Constants.UI.discoverCollectionViewCellID)
    }
    
    func reloadCollectionView(_ collectionView: UICollectionView?) {
        guard let collectionView = collectionView else {
            return
        }
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
    }
}

