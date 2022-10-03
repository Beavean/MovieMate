//
//  VideoViewModel.swift
//  The Movie Database
//
//  Created by Beavean on 13.08.2022.
//

import Foundation

protocol VideoViewModeling {
    
    var videoDetails: [MediaVideos.Video]? { get set }
    var mediaType: String? { get set }
    var mediaID: Int? { get set }
    var onDataUpdated: () -> Void { get set }
    
    func updateData()
}

final class VideoViewModel: VideoViewModeling {
    
    //MARK: - Variables
    
    var videoDetails: [MediaVideos.Video]?
    var mediaType: String?
    var mediaID: Int?
    var onDataUpdated = { }
    
    //MARK: - Data update and process
    
    func updateData() {
        receiveMedia { [weak self] in
            self?.onDataUpdated()
        }
    }
    
    func receiveMedia(completion: @escaping()->()) {
        guard let mediaID = mediaID, let mediaType = mediaType else { return }
        NetworkManager.shared.getMediaVideos(mediaID: mediaID, mediaType: mediaType) { [weak self] video in
            self?.videoDetails = video
            completion()
        }
    }
}
