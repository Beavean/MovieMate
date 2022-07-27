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
    
    @IBOutlet var playerView: YTPlayerView!
    @IBOutlet weak var mediaBackdropPosterImageView: UIImageView!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    @IBOutlet weak var mediaTitleLabel: UILabel!
    @IBOutlet weak var mediaReleaseDateLabel: UILabel!
    @IBOutlet weak var mediaGenresLabel: UILabel!
    @IBOutlet weak var mediaPosterImageView: UIImageView!
    @IBOutlet weak var mediaOverviewLabel: UILabel!
    @IBOutlet weak var mediaRatingLabel: UILabel!
    @IBOutlet weak var mediaVotesCountLabel: UILabel!
    
    var searchIndex = Int()
    var mediaID = Int()
    var mediaType = String()
    var mediaBackdropPosterLink: String? = nil
    var media: MoviesSearch.Results? = nil
    var mediaVideos: MediaVideos? = nil
    var realmMediaData: MediaRealm? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadMediaVideos()
        mediaBackdropPosterImageView.layer.cornerRadius = mediaBackdropPosterImageView.frame.height / 50
    }
    
    
    func configureViewController(with model: MoviesSearch.Results) {
        if let backdropPath = model.backdropPath {
            self.mediaBackdropPosterImageView.sd_setImage(with: URL(string: K.baseImageUrl + (backdropPath)))
            if let posterPath = model.posterPath {
                self.mediaPosterImageView.sd_setImage(with: URL(string: K.baseImageUrl + posterPath))
                self.mediaPosterImageView.layer.cornerRadius = self.mediaPosterImageView.frame.width / 10
                
            }
            self.mediaTitleLabel.text = (model.title ?? "").isEmpty == false ? model.title : model.name
            self.mediaOverviewLabel.text = model.overview
            self.mediaGenresLabel.text = "Genres: \(GenresDecoder.shared.decodeMovieGenreIDs(idNumbers: model.genreIDs!))"
            self.mediaReleaseDateLabel.text = (model.releaseDate ?? "").isEmpty == false ? MediaDateFormatter.shared.formatDate(from: model.releaseDate ?? "") : MediaDateFormatter.shared.formatDate(from: model.firstAirDate ?? "")
            self.mediaRatingLabel.text = String(format: "%.1f", model.voteAverage!)
            self.mediaVotesCountLabel.text = "\(String(describing: model.voteCount!)) votes"
            if RealmDataManager.shared.checkIfAlreadySaved(id: model.id!) {
                self.saveButtonOutlet.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                self.saveButtonOutlet.setTitle("Saved", for: .normal)
            }
        } else { return }
    }
    
    
    func configureViewController(with object: MediaRealm) {
        self.mediaBackdropPosterImageView.sd_setImage(with: URL(string: K.baseImageUrl + (object.backdropPath)))
        self.mediaPosterImageView.sd_setImage(with: URL(string: K.baseImageUrl + object.posterPath))
        self.mediaPosterImageView.layer.cornerRadius = self.mediaPosterImageView.frame.width / 10
        self.mediaTitleLabel.text = object.title
        self.mediaOverviewLabel.text = object.overview
        self.mediaGenresLabel.text = object.genreIDs.isEmpty == false ? object.genreIDs : "Unspecified"
        self.mediaReleaseDateLabel.text = object.releaseDate.isEmpty == false ? object.releaseDate : "-"
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
                RealmDataManager.shared.saveMedia(from: self.media!)
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
        let url = K.baseUrl + K.movieKey + String(mediaID) + K.videosKey + K.apiKey
        AF.request(url).responseData { response in
            do {
                if let receivedData = response.data, let allData = try JSONDecoder().decode(MediaVideos?.self, from: receivedData)  {
                    self.mediaVideos = allData
                    guard let mediaVideoKey = allData.results?.first?.key else {
                        return
                    }
                    self.playerView.load(withVideoId: mediaVideoKey, playerVars: ["playsinline": 1])
                }
            } catch {
                print(error)
            }
        }
    }
}


