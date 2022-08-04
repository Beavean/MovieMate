//
//  DetailViewController.swift
//  The Movie Database
//
//  Created by Beavean on 20.07.2022.
//

import UIKit
import Alamofire
import youtube_ios_player_helper

class DetailViewController: UIViewController {
    
    @IBOutlet private var playerView: YTPlayerView!
    @IBOutlet private weak var mediaBackdropPosterImageView: UIImageView!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var mediaTitleLabel: UILabel!
    @IBOutlet private weak var mediaReleaseDateLabel: UILabel!
    @IBOutlet private weak var mediaGenresLabel: UILabel!
    @IBOutlet private weak var mediaPosterImageView: UIImageView!
    @IBOutlet private weak var mediaOverviewLabel: UILabel!
    @IBOutlet private weak var mediaRatingLabel: UILabel!
    @IBOutlet private weak var mediaVotesCountLabel: UILabel!
    @IBOutlet private weak var mediaBackgroundBlurImage: UIImageView!
    @IBOutlet private weak var mediaTaglineLabel: UILabel!
    @IBOutlet private weak var mediaRuntimeLabel: UILabel!
    
    var mediaID: Int?
    var mediaType: String?
    var media: MediaSearch.Results?
    var mediaVideos: MediaVideos?
    var realmMediaData: RealmMediaObject?
    
    //MARK: - DetailViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - SaveButton interaction
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        self.saveButtonPressed(button: saveButton, mediaID: mediaID, mediaType: mediaType) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func configureWithMediaID(mediaID: Int?, mediaType: String?) {
        guard let mediaID = mediaID, let mediaType = mediaType else { return }
        NetworkManager.shared.getMediaDetails(mediaID: mediaID, mediaType: mediaType) { model in
            if let backdropPath = model.backdropPath {
                self.mediaBackdropPosterImageView.sd_setImage(with: URL(string: Constants.Network.baseImageUrl + backdropPath))
            } else {
                self.mediaBackdropPosterImageView.isHidden = true
            }
            if let posterPath = model.posterPath {
                self.mediaPosterImageView.sd_setImage(with: URL(string: Constants.Network.baseImageUrl + posterPath))
                self.mediaPosterImageView.addSmallCornerRadius()
                self.mediaBackgroundBlurImage.sd_setImage(with: URL(string: Constants.Network.baseImageUrl + posterPath))
                self.mediaBackgroundBlurImage.applyBlurEffect()
            } else {
                self.mediaPosterImageView.isHidden = true
            }
            self.mediaTaglineLabel.text = model.tagline
            self.mediaTitleLabel.text = model.title ?? model.name
            self.mediaOverviewLabel.text = model.overview
            self.mediaGenresLabel.text = model.convertGenresIntoString()
            self.mediaReleaseDateLabel.text = MediaDateFormatter.shared.formatDate(from: model.firstAirDate ?? model.releaseDate)
            self.mediaRatingLabel.text = String(format: "%.1f", model.voteAverage!)
            self.mediaVotesCountLabel.text = "\(String(describing: model.voteCount!)) votes"
            self.mediaRuntimeLabel.text = model.convertTimeDuration() ?? model.convertSeasonsAndEpisodes()
            self.saveButton.changeImageIfSaved(condition: RealmManager.shared.checkIfAlreadySaved(id: model.id))
            NetworkManager.shared.getMediaVideos(mediaID: mediaID, mediaType: mediaType) { video in
                if let mediaVideoKey = video.last?.key {
                    self.playerView.load(withVideoId: mediaVideoKey, playerVars: ["playsinline": 1])
                } else {
                    self.playerView.isHidden = true
                }
            }
        }
    }
}



