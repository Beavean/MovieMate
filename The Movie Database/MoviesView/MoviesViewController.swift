//
//  MoviesViewController.swift
//  The Movie Database
//
//  Created by Beavean on 08.08.2022.
//

import UIKit

final class MoviesViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var nowPlayingCollectionView: UICollectionView!
    @IBOutlet var upcomingCollectionView: UICollectionView!
    @IBOutlet var topRatedCollectionView: UICollectionView!

    // MARK: - Properties

    var nowPlayingMovies = [MediaDetails]() {
        didSet { nowPlayingCollectionView.reloadData() }
    }

    var upcomingMovies = [MediaDetails]() {
        didSet { upcomingCollectionView.reloadData() }
    }

    var topRatedMovies = [MediaDetails]() {
        didSet { topRatedCollectionView.reloadData() }
    }

    private var viewModel: MoviesViewModeling = MoviesViewModel()

    // MARK: - Discover View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCompletions()
        viewModel.updateData()
        setupCollectionView(nowPlayingCollectionView)
        setupCollectionView(upcomingCollectionView)
        setupCollectionView(topRatedCollectionView)
    }

    // MARK: - Completions to run after model receives data

    private func setupCompletions() {
        showLoader(true)
        viewModel.onDataUpdated = { [weak self] in
            guard let self else { return }
            self.nowPlayingMovies = self.viewModel.nowPlayingMovies
            self.upcomingMovies = self.viewModel.upcomingMovies
            self.topRatedMovies = self.viewModel.topRatedMovies
            self.showLoader(false)
        }
    }

    // MARK: - Collection View setups

    private func setupCollectionView(_ collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: Constants.UI.discoverCollectionViewCellID, bundle: nil), forCellWithReuseIdentifier: Constants.UI.discoverCollectionViewCellID)
    }
}

// MARK: - UICollectionViewDataSource

extension MoviesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        var countOfItems = 0
        switch collectionView {
        case nowPlayingCollectionView: countOfItems = nowPlayingMovies.count
        case upcomingCollectionView: countOfItems = upcomingMovies.count
        case topRatedCollectionView: countOfItems = topRatedMovies.count
        default: return 0
        }
        return countOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.UI.discoverCollectionViewCellID, for: indexPath) as? DiscoverCollectionViewCell
        var item: MediaDetails
        switch collectionView {
        case nowPlayingCollectionView: item = nowPlayingMovies[indexPath.row]
        case upcomingCollectionView: item = upcomingMovies[indexPath.row]
        case topRatedCollectionView: item = topRatedMovies[indexPath.row]
        default: return UICollectionViewCell()
        }
        guard let cell = cell else { return UICollectionViewCell() }
        cell.configure(with: item)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MoviesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Constants.UI.mainStoryboardName, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: Constants.UI.detailViewControllerID) as? DetailViewController {
            var delegatingMediaID: Int
            switch collectionView {
            case nowPlayingCollectionView:
                guard let mediaID = nowPlayingMovies[indexPath.row].id else { return }
                delegatingMediaID = mediaID
            case upcomingCollectionView:
                guard let mediaID = upcomingMovies[indexPath.row].id else { return }
                delegatingMediaID = mediaID
            case topRatedCollectionView:
                guard let mediaID = topRatedMovies[indexPath.row].id else { return }
                delegatingMediaID = mediaID
            default: return
            }
            viewController.mediaID = delegatingMediaID
            viewController.mediaType = Constants.Network.movieType
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
