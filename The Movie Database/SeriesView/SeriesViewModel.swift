//
//  SeriesViewModel.swift
//  The Movie Database
//
//  Created by Beavean on 09.08.2022.
//

import Foundation

protocol SeriesViewModeling {
    var popularSeries: [BasicMedia.Results] { get set }
    var latestSeries: [BasicMedia.Results] { get set }
    var topRatedSeries: [BasicMedia.Results] { get set }
    var onDataUpdated: () -> Void { get set }
    
    func updateData()
}

final class SeriesViewModel: SeriesViewModeling {
    
    //MARK: - Variables
    
    var popularSeries: [BasicMedia.Results] = []
    var latestSeries: [BasicMedia.Results] = []
    var topRatedSeries: [BasicMedia.Results] = []
    var onDataUpdated = { }
    
    //MARK: - Model data update and completions
    
    func updateData() {
        receiveAllSeries { [weak self] in
            self?.onDataUpdated()
        }
    }
    
    func receiveAllSeries(completion: @escaping ()->()) {
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
