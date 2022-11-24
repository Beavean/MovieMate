//
//  SearchViewModel.swift
//  The Movie Database
//
//  Created by Beavean on 01.08.2022.
//

import Foundation

protocol SearchViewModeling {
    var mediaSearchResults: [MediaDetails] { get set }
    var enteredQuery: String { get set }
    var mediaTypeSegmentedControl: Int { get set }
    var mediaType: String? { get set }
    var onDataUpdated: () -> Void { get set }
    func updateData()
}

final class SearchViewModel: SearchViewModeling {

    // MARK: - Properties

    var mediaSearchResults: [MediaDetails] = []
    var enteredQuery = nil ?? ""
    var mediaTypeSegmentedControl = 0
    var mediaType: String?
    var onDataUpdated = { }

    // MARK: - Model data update and completions

    func updateData() {
        receiveMedia { [weak self] in
            self?.onDataUpdated()
        }
    }

    func receiveMedia(completion: @escaping () -> Void) {
        if enteredQuery.isEmpty {
            switch mediaTypeSegmentedControl {
            case 1:
                NetworkManager.shared.getTrendingSeries { [weak self] media in
                    self?.mediaType = Constants.Network.tvSeriesType
                    self?.mediaSearchResults = media
                    completion()
                }
            case 0:
                NetworkManager.shared.getTrendingMovies { [weak self] media in
                    self?.mediaType = Constants.Network.movieType
                    self?.mediaSearchResults = media
                    completion()
                }
            default:
                break
            }
        } else {
            switch mediaTypeSegmentedControl {
            case 1:
                NetworkManager.shared.getSearchedSeries(enteredQuery: enteredQuery) { [weak self] media in
                    self?.mediaType = Constants.Network.tvSeriesType
                    self?.mediaSearchResults = media
                    completion()
                }
            case 0:
                NetworkManager.shared.getSearchedMovies(enteredQuery: enteredQuery) { [weak self] media in
                    self?.mediaType = Constants.Network.movieType
                    self?.mediaSearchResults = media
                    completion()
                }
            default:
                break
            }
        }
    }
}
