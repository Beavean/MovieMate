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
    @IBOutlet private weak var saveButtonOutlet: UIButton!
    @IBOutlet private weak var mediaTitleLabel: UILabel!
    @IBOutlet private weak var mediaReleaseDateLabel: UILabel!
    @IBOutlet private weak var mediaGenresLabel: UILabel!
    @IBOutlet private weak var mediaPosterImageView: UIImageView!
    @IBOutlet private weak var mediaOverviewLabel: UILabel!
    @IBOutlet private weak var mediaRatingLabel: UILabel!
    @IBOutlet private weak var mediaVotesCountLabel: UILabel!
    
    var searchIndex = Int()
    var mediaID = Int()
    var mediaType = String()
    var mediaBackdropPosterLink: String? = nil
    var media: MediaSearch.Results? = nil
    var mediaVideos: MediaVideos? = nil
    var realmMediaData: MediaRealm? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        mediaBackdropPosterImageView.layer.cornerRadius = mediaBackdropPosterImageView.frame.height / 50
    }
    
    func configureViewController(with model: MediaSearch.Results) {
        loadMediaVideos()
        if let backdropPath = model.backdropPath {
            self.mediaBackdropPosterImageView.sd_setImage(with: URL(string: Constants.Network.baseImageUrl + (backdropPath)))
        } else {
            self.mediaBackdropPosterImageView.isHidden = true
        }
        if let posterPath = model.posterPath {
            self.mediaPosterImageView.sd_setImage(with: URL(string: Constants.Network.baseImageUrl + posterPath))
            self.mediaPosterImageView.layer.cornerRadius = self.mediaPosterImageView.frame.width / 10
        } else {
            self.mediaPosterImageView.isHidden = true
        }
        self.mediaTitleLabel.text = (model.title ?? "").isEmpty == false ? model.title : model.name
        self.mediaOverviewLabel.text = model.overview
        self.mediaGenresLabel.text = GenresDecoder.shared.decodeMovieGenreIDs(idNumbers: model.genreIDs!).isEmpty == false ? GenresDecoder.shared.decodeMovieGenreIDs(idNumbers: model.genreIDs!) : "Genre is not specified"
        self.mediaReleaseDateLabel.text = (model.releaseDate ?? "").isEmpty == false ? MediaDateFormatter.shared.formatDate(from: model.releaseDate!) : "Unknown"
        self.mediaRatingLabel.text = String(format: "%.1f", model.voteAverage!)
        self.mediaVotesCountLabel.text = "\(String(describing: model.voteCount!)) votes"
        if RealmDataManager.shared.checkIfAlreadySaved(id: model.id!) {
            self.saveButtonOutlet.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            self.saveButtonOutlet.setTitle("Saved", for: .normal)
        }
    }
    
    func configureViewController(with object: MediaRealm) {
        self.mediaType = object.mediaType
        loadMediaVideos()
        if object.backdropPath.isEmpty == true {
            mediaBackdropPosterImageView.isHidden = true
        } else {
            self.mediaBackdropPosterImageView.sd_setImage(with: URL(string: Constants.Network.baseImageUrl + (object.backdropPath)))
            
        }
        self.mediaPosterImageView.sd_setImage(with: URL(string: Constants.Network.baseImageUrl + object.posterPath))
        self.mediaPosterImageView.layer.cornerRadius = self.mediaPosterImageView.frame.width / 10
        self.mediaTitleLabel.text = object.title
        self.mediaOverviewLabel.text = object.overview
        self.mediaGenresLabel.text = object.genreIDs.isEmpty == false ? object.genreIDs : "Unspecified"
        self.mediaReleaseDateLabel.text = object.releaseDate.isEmpty == false ? object.releaseDate : "Unknown"
        self.mediaRatingLabel.text = String(format: "%.1f", object.voteAverage).isEmpty == false ? String(format: "%.1f", object.voteAverage) : "-"
        self.mediaVotesCountLabel.text = "\(String(describing: object.voteCount)) votes"
        if RealmDataManager.shared.checkIfAlreadySaved(id: object.id) {
            self.saveButtonOutlet.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            self.saveButtonOutlet.setTitle("Saved", for: .normal)
        } else { return }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if RealmDataManager.shared.checkIfAlreadySaved(id: mediaID) {
            let alert = UIAlertController(title: "Already saved", message: "Do you want to remove it?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default)
            let deleteAction = UIAlertAction(title: "Remove", style: .default) { action in
                RealmDataManager.shared.deleteMedia(id: self.mediaID)
                self.navigationController?.popToRootViewController(animated: true)
                
            }
            alert.view.tintColor = UIColor.label
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Save it?", message: "This will save the page to the watch list", preferredStyle: .alert)
            let saveAction = UIAlertAction(title: "Save", style: .default) { action in
                RealmDataManager.shared.saveMedia(from: self.media!, mediaType: self.mediaType)
                self.saveButtonOutlet.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                self.saveButtonOutlet.setTitle("Saved", for: .normal)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default)
            alert.view.tintColor = UIColor.label
            alert.addAction(cancelAction)
            alert.addAction(saveAction)
            present(alert, animated: true)
        }
    }
    
    func loadMediaVideos() {
        guard let url = URL(string: Constants.Network.baseUrl + mediaType + "/" + String(mediaID) + Constants.Network.videosKey + Constants.Network.apiKey) else { return }
        AF.request(url).responseData { response in
            do {
                if let receivedData = response.data, let allData = try JSONDecoder().decode(MediaVideos?.self, from: receivedData)  {
                    self.mediaVideos = allData
                    guard let mediaVideoKey = allData.results?.first?.key else {
                        return
                    }
                    if mediaVideoKey.isEmpty {
                        self.playerView.isHidden = true
                    } else {
                        self.playerView.load(withVideoId: mediaVideoKey, playerVars: ["playsinline": 1])
                    }
                }
            } catch {
                print("Error loading media videos: \(error)")
            }
        }
    }
}


