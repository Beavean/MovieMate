//
//  DiscoverViewModel.swift
//  The Movie Database
//
//  Created by Beavean on 06.08.2022.
//

import Foundation

class DiscoverViewModel {
    
    var nowPlayingMedia: [MediaSearch.Results] = []
    
    func receiveNowPlayingMedia(completion: @escaping (()->())) {
        NetworkManager.shared.getNowPlaying { movies in
            self.nowPlayingMedia = movies
            completion()
        }
    }
}
