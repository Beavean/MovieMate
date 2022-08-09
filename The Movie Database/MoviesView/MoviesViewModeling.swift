//
//  MoviesViewModel.swift
//  The Movie Database
//
//  Created by Beavean on 08.08.2022.
//

import UIKit

protocol MoviesViewModeling {
    var nowPlayingMovies: [BasicMedia.Results] { get set }
    var upcomingMovies: [BasicMedia.Results] { get set }
    var topRatedMovies: [BasicMedia.Results] { get set }
    var onDataUpdated: () -> Void { get set }
    
    func updateData()
}

class MoviesViewModel: MoviesViewModeling {
    
    var nowPlayingMovies: [BasicMedia.Results] = []
    var upcomingMovies: [BasicMedia.Results] = []
    var topRatedMovies: [BasicMedia.Results] = []
    var onDataUpdated = { }
    
    func updateData() {
        receiveAllMovies { [weak self] in
            self?.onDataUpdated()
        }
    }
    
    func receiveAllMovies(completion: @escaping (()->())) {
        NetworkManager.shared.getNowPlayingMovies { movies in
            self.nowPlayingMovies = movies
            completion()
        }
        NetworkManager.shared.getUpcomingMovies { movies in
            self.upcomingMovies = movies.reversed()
            completion()
        }
        NetworkManager.shared.getTopRatedMovies { movies in
            self.topRatedMovies = movies
            completion()
        }
    }
}
