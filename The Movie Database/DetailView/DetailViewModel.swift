//
//  DetailViewModel.swift
//  The Movie Database
//
//  Created by Beavean on 04.08.2022.
//

import Foundation

protocol DetailViewModeling {
    var onError: (String) -> Void { get set }
    var onDataUpdated: () -> Void { get set }
    func updateData()
    
}

class DetailViewModel: DetailViewModeling {
    
     var mediaBackdropPoster: String?
     var mediaTitle: String?
     var mediaReleaseDate: String?
     var mediaGenres: String?
     var mediaPoster: String?
     var mediaOverview: String?
     var mediaRating: String?
     var mediaVotesCount: String?
     var mediaBackgroundBlurImage: String?
     var mediaTagline: String?
     var mediaRuntime: String?
    
    var onError: (String) -> Void = { _ in }
    var onDataUpdated = { }
    
    func updateData(mediaID: Int?, mediaType: String?) {
            guard let mediaID = mediaID, let mediaType = mediaType else { return }
            NetworkManager.shared.getMediaDetails(mediaID: mediaID, mediaType: mediaType) { model in
                if let backdropPath = model.backdropPath {
                }
                if let posterPath = model.posterPath {
                }
                self.mediaTagline = model.tagline
                self.mediaTitle = model.title ?? model.name
                self.mediaOverview = model.overview
                self.mediaGenres = model.convertGenresIntoString()
                self.mediaReleaseDate = MediaDateFormatter.shared.formatDate(from: model.firstAirDate ?? model.releaseDate)
                self.mediaRating = String(format: "%.1f", model.voteAverage!)
                self.mediaVotesCount = "\(String(describing: model.voteCount!)) votes"
                self.mediaRuntime = model.convertTimeDuration() ?? model.convertSeasonsAndEpisodes()
                self.saveButton.changeImageIfSaved(condition: RealmManager.shared.checkIfAlreadySaved(id: model.id))
                NetworkManager.shared.getMediaVideos(mediaID: mediaID, mediaType: mediaType) { video in
                    if let mediaVideoKey = video.last?.key {
                        self.playerView.load(withVideoId: mediaVideoKey, playerVars: ["playsinline": 1])
                    }
                }
            }
        onDataUpdated()
    }
}
