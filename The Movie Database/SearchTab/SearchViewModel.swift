//
//  SearchViewModel.swift
//  The Movie Database
//
//  Created by Beavean on 01.08.2022.
//

import UIKit

class SearchViewModel {
    
    var mediaSearchResults: [MediaSearch.Results] = []
    var enteredQuery: String?
    var mediaType: String?
    
    let networkManager = AnotherNetworkManager()
    
    func receiveMedia(mediaTypeSegmentedControl: Int, searchQuery: String, completion: @escaping (()->())) {
        if !searchQuery.isEmpty {
            switch mediaTypeSegmentedControl {
            case 0:
                networkManager.getSearchedMovies(enteredQuery: searchQuery) { media in
                    self.mediaSearchResults = media
                    completion()
                }
            case 1:
                networkManager.getSearchedSeries(enteredQuery: searchQuery) { media in
                    self.mediaSearchResults = media
                    completion()
                }
            default:
                networkManager.getSearchedMovies(enteredQuery: searchQuery) { media in
                    self.mediaSearchResults = media
                    completion()
                }
            }
        } else {
            switch mediaTypeSegmentedControl {
            case 0:
                networkManager.getTrendingMovies { media in
                    self.mediaSearchResults = media
                    completion()
                }
            case 1:
                networkManager.getTrendingSeries { media in
                    self.mediaSearchResults = media
                    completion()
                }
            default:
                networkManager.getTrendingMovies { media in
                    self.mediaSearchResults = media
                    completion()
                }
            }
        }
    }
}
