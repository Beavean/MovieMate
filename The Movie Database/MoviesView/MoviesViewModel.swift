//
//  MoviesViewModel.swift
//  The Movie Database
//
//  Created by Beavean on 08.08.2022.
//

import Foundation

protocol MoviesViewModeling {
    var nowPlayingMovies: [MediaDetails] { get set }
    var upcomingMovies: [MediaDetails] { get set }
    var topRatedMovies: [MediaDetails] { get set }
    var onDataUpdated: () -> Void { get set }

    func updateData()
}

final class MoviesViewModel: MoviesViewModeling {
    // MARK: - Properties

    var nowPlayingMovies: [MediaDetails] = []
    var upcomingMovies: [MediaDetails] = []
    var topRatedMovies: [MediaDetails] = []
    var onDataUpdated = {}

    // MARK: - Model data update and completions

    func updateData() {
        receiveAllMovies { [weak self] in
            self?.onDataUpdated()
        }
    }

    // MARK: - Receiving data after update

    private func receiveAllMovies(completion: @escaping () -> Void) {
        NetworkManager.shared.getNowPlayingMovies { [weak self] movies in
            self?.nowPlayingMovies = movies
            completion()
        }
        NetworkManager.shared.getUpcomingMovies { [weak self] movies in
            self?.upcomingMovies = movies.reversed()
            completion()
        }
        NetworkManager.shared.getTopRatedMovies { [weak self] movies in
            self?.topRatedMovies = movies
            completion()
        }
    }
}
