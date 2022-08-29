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
        popularCollectionView.dataSource = self
        latestCollectionView.dataSource = self
        topRatedCollectionView.dataSource = self
        popularCollectionView.delegate = self
        latestCollectionView.delegate = self
        topRatedCollectionView.delegate = self
        self.popularCollectionView.register(UINib(nibName: Constants.UI.discoverCollectionViewCellID, bundle: nil), forCellWithReuseIdentifier: Constants.UI.discoverCollectionViewCellID)
        self.latestCollectionView.register(UINib(nibName: Constants.UI.discoverCollectionViewCellID, bundle: nil), forCellWithReuseIdentifier: Constants.UI.discoverCollectionViewCellID)
        self.topRatedCollectionView.register(UINib(nibName: Constants.UI.discoverCollectionViewCellID, bundle: nil), forCellWithReuseIdentifier: Constants.UI.discoverCollectionViewCellID)
    }
    
    override func viewWillLayoutSubviews() {
        popularCollectionView.reloadData()
        latestCollectionView.reloadData()
        topRatedCollectionView.reloadData()
        popularCollectionView.layoutIfNeeded()
        latestCollectionView.layoutIfNeeded()
        topRatedCollectionView.layoutIfNeeded()
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
            self?.popularCollectionView.reloadData()
            self?.latestCollectionView.reloadData()
            self?.topRatedCollectionView.reloadData()
            self?.popularCollectionView.layoutIfNeeded()
            self?.latestCollectionView.layoutIfNeeded()
            self?.topRatedCollectionView.layoutIfNeeded()
        }
    }
}

