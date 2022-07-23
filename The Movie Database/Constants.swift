//
//  Constants.swift
//  The Movie Database
//
//  Created by Beavean on 19.07.2022.
//

import Foundation

struct K {
    static let apiKey = "?api_key=2cfd0db8398a10e5a9777f73b2218ca9"
    static let baseUrl = "https://api.themoviedb.org/3/"
    static let baseImageUrl = "https://image.tmdb.org/t/p/w500/"
    static let trendingMoviesKey = "trending/movie/day"
    static let movieSearchKey = "search/movie"
    static let movieSearchQuery = "&query="
    static let getMovieByID = "movie/"
    static let popularKey = "/popular"
    
    static let MoviesCellReuseID = "SearchTableViewCell"
    static let DetailViewControllerID = "DetailViewController"
}
