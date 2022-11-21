//
//  MoviesViewModel.swift
//  The Movie Database
//
//  Created by Beavean on 08.08.2022.
//

import Foundation

protocol MoviesViewModeling {
    var nowPlayingMovies: [BasicMedia.Results] { get set }
    var upcomingMovies: [BasicMedia.Results] { get set }
    var topRatedMovies: [BasicMedia.Results] { get set }
    var onDataUpdated: () -> Void { get set }

    func updateData()
}

final class MoviesViewModel: MoviesViewModeling {

    // MARK: - Variables

    var nowPlayingMovies: [BasicMedia.Results] = []
    var upcomingMovies: [BasicMedia.Results] = []
    var topRatedMovies: [BasicMedia.Results] = []
    var onDataUpdated = { }

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
