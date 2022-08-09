//
//  Constants.swift
//  The Movie Database
//
//  Created by Beavean on 19.07.2022.
//

import Foundation

struct Constants {
    
    struct Network {
        static let apiKey = "?api_key=2cfd0db8398a10e5a9777f73b2218ca9"
        static let baseUrl = "https://api.themoviedb.org/3/"
        static let baseImageUrl = "https://image.tmdb.org/t/p/w780/"
        static let movieType = "movie"
        static let tvSeriesType = "tv"
    }
    
    struct UI {
        static let cornerRadiusRatio = 0.05
        static let mediaTableViewCellReuseID = String(describing: MediaTableViewCell.self)
        static let detailViewControllerID = String(describing: DetailViewController.self)
        static let discoverCollectionViewCellID = String(describing: DiscoverCollectionViewCell.self)
        static let alreadySavedButtonImage = "checkmark.square"
        static let saveButtonImage = "plus.square"
        static let emptyPosterImage = "questionmark.square"
        static let mainStoryboardName = "Main"
    }
}
