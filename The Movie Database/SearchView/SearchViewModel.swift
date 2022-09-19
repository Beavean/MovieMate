//
//  SearchViewModel.swift
//  The Movie Database
//
//  Created by Beavean on 01.08.2022.
//

import Foundation

protocol SearchViewModeling {
    var mediaSearchResults: [BasicMedia.Results] { get set }
    var enteredQuery: String { get set }
    var mediaTypeSegmentedControl: Int { get set }
    var mediaType: String? { get set }
    var onDataUpdated: () -> Void { get set }
    func updateData()
}


class SearchViewModel: SearchViewModeling {
    
    //MARK: - Variables
    
    var mediaSearchResults: [BasicMedia.Results] = []
    var enteredQuery = nil ?? ""
    var mediaTypeSegmentedControl = 0
    var mediaType: String?
    var onDataUpdated = { }
    
    //MARK: - Model data update and completions
    
    func updateData() {
        receiveMedia { [weak self] in
            self?.onDataUpdated()
        }
    }
    
    func receiveMedia(completion: @escaping ()->()) {
        if enteredQuery.isEmpty {
            switch mediaTypeSegmentedControl {
            case 1:
                NetworkManager.shared.getTrendingSeries { media in
                    self.mediaType = Constants.Network.tvSeriesType
                    self.mediaSearchResults = media
                    completion()
                }
            default:
                NetworkManager.shared.getTrendingMovies { media in
                    self.mediaType = Constants.Network.movieType
                    self.mediaSearchResults = media
                    completion()
                }
            }
        } else {
            switch mediaTypeSegmentedControl {
            case 1:
                NetworkManager.shared.getSearchedSeries(enteredQuery: enteredQuery) { media in
                    self.mediaType = Constants.Network.tvSeriesType
                    self.mediaSearchResults = media
                    completion()
                }
            default:
                NetworkManager.shared.getSearchedMovies(enteredQuery: enteredQuery) { media in
                    self.mediaType = Constants.Network.movieType
                    self.mediaSearchResults = media
                    completion()
                }
            }
        }
    }
}
