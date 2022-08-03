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
    
    var mediaID: Int?
    var mediaType: String?
    var mediaBackdropPosterLink: String?
    var media: MediaSearch.Results?
    var mediaVideos: MediaVideos?
    var realmMediaData: RealmMediaObject?
    
    //MARK: - DetailViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    //MARK: - SaveButton interaction
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        guard let mediaID = self.mediaID else { return }
        if RealmManager.shared.checkIfAlreadySaved(id: mediaID) {
            let alert = UIAlertController(title: "Already saved", message: "Do you want to remove it?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default)
            let deleteAction = UIAlertAction(title: "Remove", style: .default) { action in
                RealmManager.shared.deleteMedia(id: mediaID)
                self.navigationController?.popToRootViewController(animated: true)
            }
            alert.view.tintColor = UIColor.label
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Save it?", message: "This will add the item to the saved list", preferredStyle: .alert)
            let saveAction = UIAlertAction(title: "Save", style: .default) { action in
                guard let media = self.media, let mediaType = self.mediaType else { return }
                RealmManager.shared.saveMedia(from: media, mediaType: mediaType)
                self.saveButton.tintColor = .green
                self.saveButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default)
            alert.view.tintColor = UIColor.label
            alert.addAction(cancelAction)
            alert.addAction(saveAction)
            present(alert, animated: true)
        }
    }
    
    //MARK: - Configuring with JSON model
    
    func configureViewController(with model: MediaSearch.Results) {
        loadMediaVideos()
        if let backdropPath = model.backdropPath {
            self.mediaBackdropPosterImageView.sd_setImage(with: URL(string: Constants.Network.baseImageUrl + backdropPath))
        } else {
            self.mediaBackdropPosterImageView.isHidden = true
        }
        if let posterPath = model.posterPath {
            self.mediaPosterImageView.sd_setImage(with: URL(string: Constants.Network.baseImageUrl + posterPath))
            self.mediaPosterImageView.layer.cornerRadius = self.mediaPosterImageView.frame.height * Constants.UI.cornerRadiusRatio
            self.mediaBackgroundBlurImage.sd_setImage(with: URL(string: Constants.Network.baseImageUrl + posterPath))
            self.mediaBackgroundBlurImage.applyBlurEffect()
        } else {
            self.mediaPosterImageView.isHidden = true
        }
        self.mediaTitleLabel.text = (model.title ?? "").isEmpty == false ? model.title : model.name
        self.mediaOverviewLabel.text = model.overview
        self.mediaGenresLabel.text = MediaGenresDecoder.shared.decodeMovieGenreIDs(idNumbers: model.genreIDs!)
        self.mediaReleaseDateLabel.text = (model.releaseDate ?? "").isEmpty == false ? MediaDateFormatter.shared.formatDate(from: model.releaseDate ?? "") : MediaDateFormatter.shared.formatDate(from: model.firstAirDate ?? "")
        self.mediaRatingLabel.text = String(format: "%.1f", model.voteAverage!)
        self.mediaVotesCountLabel.text = "\(String(describing: model.voteCount!)) votes"
        saveButton.changeImageIfSaved(condition: RealmManager.shared.checkIfAlreadySaved(id: model.id))

    }
    
    //MARK: - Configuring with Realm object
    
    func configureViewController(with object: RealmMediaObject) {
        self.mediaType = object.mediaType
        loadMediaVideos()
        if object.backdropPath.isEmpty == true {
            mediaBackdropPosterImageView.isHidden = true
        } else {
            self.mediaBackdropPosterImageView.sd_setImage(with: URL(string: Constants.Network.baseImageUrl + object.backdropPath))
        }
        if object.posterPath.isEmpty == true {
            mediaPosterImageView.isHidden = true
        } else {
            self.mediaPosterImageView.sd_setImage(with: URL(string: Constants.Network.baseImageUrl + object.posterPath))
            self.mediaBackgroundBlurImage.sd_setImage(with: URL(string: Constants.Network.baseImageUrl + object.posterPath))
            self.mediaBackgroundBlurImage.applyBlurEffect()
        }
        self.mediaPosterImageView.layer.cornerRadius = self.mediaPosterImageView.frame.height * Constants.UI.cornerRadiusRatio
        self.mediaTitleLabel.text = object.title
        self.mediaOverviewLabel.text = object.overview
        self.mediaGenresLabel.text = object.genreIDs
        self.mediaReleaseDateLabel.text = object.releaseDate.isEmpty == false ? object.releaseDate : "Unknown"
        self.mediaRatingLabel.text = String(format: "%.1f", object.voteAverage).isEmpty == false ? String(format: "%.1f", object.voteAverage) : "-"
        self.mediaVotesCountLabel.text = "\(String(describing: object.voteCount)) votes"
        saveButton.changeImageIfSaved(condition: RealmManager.shared.checkIfAlreadySaved(id: object.id))

    }
    
    //MARK: - Loading videos to the Youtube player
    
    func loadMediaVideos() {
        guard let mediaID = self.mediaID, let mediaType = self.mediaType else { return }
        let query = mediaType + "/" + String(mediaID) + Constants.Network.videosKey + Constants.Network.apiKey
        NetworkManager.shared.makeRequest(query: query, model: MediaVideos?.self) { data in
            if let mediaVideoKey = data?.results?.last?.key {
                self.playerView.load(withVideoId: mediaVideoKey, playerVars: ["playsinline": 1])
            } else {
                self.playerView.isHidden = true
            }
        }
    }
}



