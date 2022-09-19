//
//  Constants.swift
//  The Movie Database
//
//  Created by Beavean on 19.07.2022.
//

import Foundation

struct Constants {
    
    //MARK: - URLs and Api Keys
    
    struct Network {
        static let apiKey = "?api_key=2cfd0db8398a10e5a9777f73b2218ca9"
        static let baseUrl = "https://api.themoviedb.org/3/"
        static let baseImageUrl = "https://image.tmdb.org/t/p/w780/"
        static let movieType = "movie"
        static let tvSeriesType = "tv"
        static let trendingMovies = "trending/movie/week"
        static let trendingSeries = "trending/tv/week"
        static let searchMovies = "search/movie"
        static let searchSeries = "search/tv"
        static let nowPlayingMovies = "movie/now_playing"
        static let upcomingMovies = "movie/upcoming"
        static let topRatedMovies = "movie/top_rated"
        static let popularSeries = "tv/popular"
        static let onTheAirSeries = "tv/on_the_air"
        static let topRatedSeries = "tv/top_rated"
        static let movieDatabaseMainUrl = "https://www.themoviedb.org/"
        
        static func getDetailsRequest(mediaID: Int, mediaType: String) -> String {
            let query = "\(mediaType)/\(mediaID)"
            return query
        }
        
        static func getMediaVideos(mediaID: Int, mediaType: String) -> String {
            let query = "\(mediaType)/\(mediaID)/videos"
            return query
        }
        
    }
    
    //MARK: - UI constants and names
    
    struct UI {
        static let cornerRadiusRatio = 0.05
        static let mediaTableViewCellReuseID = String(describing: MediaTableViewCell.self)
        static let detailViewControllerID = String(describing: DetailViewController.self)
        static let discoverCollectionViewCellID = String(describing: DiscoverCollectionViewCell.self)
        static let videoViewCellID = String(describing: VideoViewCell.self)
        static let videoViewControllerID = String(describing: VideoViewController.self)
        static let alreadySavedButtonImage = "checkmark.square"
        static let saveButtonImage = "plus.square"
        static let emptyPosterImage = "questionmark.square.fill"
        static let mainStoryboardName = "Main"
    }
}



