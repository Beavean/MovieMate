//
//  DetailViewController.swift
//  The Movie Database
//
//  Created by Beavean on 20.07.2022.
//

import UIKit
import Alamofire
import youtube_ios_player_helper
import SwiftUI


class DetailViewController: UIViewController {
    
    @IBOutlet var playerView: YTPlayerView!
    @IBOutlet weak var backdropPoster: UIImageView!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    
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
        backdropPoster.layer.cornerRadius = backdropPoster.frame.height / 50
        guard let mediaVideoDetails = mediaVideos else {
            return
        }
        guard let mediaVideoKey = mediaVideoDetails.results?.first?.key else {
            return
        }
        playerView.load(withVideoId: mediaVideoKey, playerVars: ["playsinline": 1])
    }
    
    
    func configureViewController(with model: MoviesSearch.Results) {
        if let backdropPath = model.backdropPath {
            self.backdropPoster.sd_setImage(with: URL(string: K.baseImageUrl + (backdropPath)))
            if RealmDataManager.shared.checkIfAlreadySaved(id: model.id!) {
                self.saveButtonOutlet.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                self.saveButtonOutlet.setTitle("Saved", for: .normal)
            }
        } else { return }
        
    }
    
    
    func configureViewController(with realm: MediaRealm) {
        let backdropPath = realm.backdropPath
        self.backdropPoster.sd_setImage(with: URL(string: K.baseImageUrl + (backdropPath)))
        self.saveButtonOutlet.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        self.saveButtonOutlet.setTitle("Saved", for: .normal)
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
        if let media = media {
            let url = K.baseUrl + K.movieKey + String(media.id!) + K.videosKey + K.apiKey
            AF.request(url).responseData { response in
                do {
                    if let receivedData = response.data, let allData = try JSONDecoder().decode(MediaVideos?.self, from: receivedData)  {
                        self.mediaVideos = allData
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}


