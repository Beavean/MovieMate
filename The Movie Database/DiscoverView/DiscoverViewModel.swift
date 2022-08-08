//
//  DiscoverViewModel.swift
//  The Movie Database
//
//  Created by Beavean on 08.08.2022.
//

import UIKit

protocol DiscoverViewModeling {
    var nowPlayingMedia: [MediaSearch.Results] { get set }
    var onDataUpdated: () -> Void { get set }
    func updateData()
}

class DiscoverViewModel: DiscoverViewModeling {
    
    var nowPlayingMedia: [MediaSearch.Results] = []
    var onDataUpdated = { }
    
    func updateData() {
        receiveNowPlayingMedia { [weak self] in
            self?.onDataUpdated()
        }
    }
    
    func receiveNowPlayingMedia(completion: @escaping (()->())) {
        NetworkManager.shared.getNowPlaying { movies in
            self.nowPlayingMedia = movies
            completion()
        }
    }
}
