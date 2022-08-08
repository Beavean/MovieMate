//
//  DiscoverViewModel.swift
//  The Movie Database
//
//  Created by Beavean on 08.08.2022.
//

import UIKit

protocol DiscoverViewModeling {
    var nowPlayingMedia: [MediaSearch.Results] { get set }
    var upcomingMedia: [MediaSearch.Results] { get set }
    var topRatedMedia: [MediaSearch.Results] { get set }
    var onDataUpdated: () -> Void { get set }
    
    func updateData()
}

class DiscoverViewModel: DiscoverViewModeling {
    
    var nowPlayingMedia: [MediaSearch.Results] = []
    var upcomingMedia: [MediaSearch.Results] = []
    var topRatedMedia: [MediaSearch.Results] = []
    var onDataUpdated = { }
    
    func updateData() {
        receiveAllMedia { [weak self] in
            self?.onDataUpdated()
        }
    }
    
    func receiveAllMedia(completion: @escaping (()->())) {
        NetworkManager.shared.getNowPlaying { movies in
            self.nowPlayingMedia = movies
            completion()
        }
        NetworkManager.shared.getUpcoming { movies in
            self.upcomingMedia = movies.reversed()
            completion()
        }
        NetworkManager.shared.getTopRated { movies in
            self.topRatedMedia = movies
            completion()
        }
    }
}
