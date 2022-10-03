//
//  DetailViewModel.swift
//  The Movie Database
//
//  Created by Beavean on 04.08.2022.
//

import Foundation

protocol DetailViewModeling {
    var mediaDetails: MediaDetails? { get set }
    var mediaType: String? { get set }
    var mediaID: Int? { get set }
    var mediaVideoKey: String? { get set }
    var onDataUpdated: () -> Void { get set }
    
    func updateData()
}

final class DetailViewModel: DetailViewModeling {
    
    //MARK: - Variables
    
    var mediaDetails: MediaDetails?
    var mediaType: String?
    var mediaVideoKey: String?
    var mediaID: Int?
    var onDataUpdated = { }
    
    //MARK: - Model data update and completions
    
    func updateData() {
        receiveMedia { [weak self] in
            self?.onDataUpdated()
        }
    }
    
    func receiveMedia(completion: @escaping()->()) {
        guard let mediaID = mediaID, let mediaType = mediaType else { return }
        NetworkManager.shared.getMediaDetails(mediaID: mediaID, mediaType: mediaType) { [weak self] media in
            self?.mediaDetails = media
            NetworkManager.shared.getMediaVideos(mediaID: mediaID, mediaType: mediaType) { [weak self] video in
                self?.mediaVideoKey = video.last?.key
                completion()
            }
        }
    }
}
