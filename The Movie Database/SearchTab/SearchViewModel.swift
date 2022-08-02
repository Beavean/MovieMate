//
//  SearchViewModel.swift
//  The Movie Database
//
//  Created by Beavean on 01.08.2022.
//

import UIKit

class SearchViewModel {
    
    var mediaSearchResults: [MediaSearch.Results] = []
    var enteredQuery = nil ?? ""
    var mediaTypeSegmentedControl = 0
    var mediaType = "movie"
    
    let networkManager = AnotherNetworkManager()
    
    func receiveMedia(completion: @escaping (()->())) {
        if enteredQuery.isEmpty {
            switch mediaTypeSegmentedControl {
            case 0:
                networkManager.getTrendingMovies { media in
                    self.mediaType = Constants.Network.movieType
                    self.mediaSearchResults = media
                    completion()
                }
            case 1:
                networkManager.getTrendingSeries { media in
                    self.mediaType = Constants.Network.tvSeriesType
                    self.mediaSearchResults = media
                    completion()
                }
            default:
                networkManager.getTrendingMovies { media in
                    self.mediaType = Constants.Network.movieType
                    self.mediaSearchResults = media
                    completion()
                }
            }
        } else {
            switch mediaTypeSegmentedControl {
            case 0:
                networkManager.getSearchedMovies(enteredQuery: enteredQuery) { media in
                    self.mediaType = Constants.Network.movieType
                    self.mediaSearchResults = media
                    completion()
                }
            case 1:
                networkManager.getSearchedSeries(enteredQuery: enteredQuery) { media in
                    self.mediaType = Constants.Network.tvSeriesType
                    self.mediaSearchResults = media
                    completion()
                }
            default:
                networkManager.getSearchedMovies(enteredQuery: enteredQuery) { media in
                    self.mediaType = Constants.Network.movieType
                    self.mediaSearchResults = media
                    completion()
                }
            }
        }
    }
}
