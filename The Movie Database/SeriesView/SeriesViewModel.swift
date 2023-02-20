//
//  SeriesViewModel.swift
//  The Movie Database
//
//  Created by Beavean on 09.08.2022.
//

import Foundation

protocol SeriesViewModeling {
    var popularSeries: [MediaDetails] { get set }
    var latestSeries: [MediaDetails] { get set }
    var topRatedSeries: [MediaDetails] { get set }
    var onDataUpdated: () -> Void { get set }

    func updateData()
}

final class SeriesViewModel: SeriesViewModeling {
    // MARK: - Properties

    var popularSeries: [MediaDetails] = []
    var latestSeries: [MediaDetails] = []
    var topRatedSeries: [MediaDetails] = []
    var onDataUpdated = {}

    // MARK: - Model data update and completions

    func updateData() {
        receiveAllSeries { [weak self] in
            self?.onDataUpdated()
        }
    }

    func receiveAllSeries(completion: @escaping () -> Void) {
        NetworkManager.shared.getPopularSeries { [weak self] series in
            self?.popularSeries = series
            completion()
        }
        NetworkManager.shared.getLatestSeries { [weak self] series in
            self?.latestSeries = series.reversed()
            completion()
        }
        NetworkManager.shared.getTopRatedSeries { [weak self] series in
            self?.topRatedSeries = series
            completion()
        }
    }
}
