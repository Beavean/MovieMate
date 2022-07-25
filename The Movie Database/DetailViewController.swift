//
//  DetailViewController.swift
//  The Movie Database
//
//  Created by Beavean on 20.07.2022.
//

import UIKit
import Alamofire

class DetailViewController: UIViewController {
    
    @IBOutlet weak var backdropPoster: UIImageView!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    
    var searchIndex = Int()
    var movieID = Int()
    var backdropPosterPath: String? = nil
    var media: MoviesSearch.Results? = nil
    var detailMedia: MediaDetails? = nil
    var realmData: MovieRealm? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backdropPoster.layer.cornerRadius = backdropPoster.frame.height / 40
        loadMediaDetails()
        
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
    
    
    func configureViewController(with realm: MovieRealm) {
        let backdropPath = realm.backdropPath
        self.backdropPoster.sd_setImage(with: URL(string: K.baseImageUrl + (backdropPath)))
        self.saveButtonOutlet.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        self.saveButtonOutlet.setTitle("Saved", for: .normal)
    }
    
    
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if let media = media {
            if RealmDataManager.shared.saveMedia(media: media) {
                let alert = UIAlertController(title: "Save it?", message: "This will save the page to the watch list", preferredStyle: .alert)
                let saveAction = UIAlertAction(title: "Save", style: .default) { action in
                    RealmDataManager.shared.saveMedia(media: self.media!)
                    self.saveButtonOutlet.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                    self.saveButtonOutlet.setTitle("Saved", for: .normal)
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .default)
                alert.view.tintColor = UIColor.label
                alert.addAction(cancelAction)
                alert.addAction(saveAction)
                present(alert, animated: true)
                
            } else {
                let alert = UIAlertController(title: "Already saved", message: "Do you want to delete it?", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .default)
                let deleteAction = UIAlertAction(title: "Delete", style: .default) { action in
                    RealmDataManager.shared.deleteMedia(id: media.id!)
                    self.saveButtonOutlet.setImage(UIImage(systemName: "bookmark"), for: .normal)
                    self.saveButtonOutlet.setTitle("Save", for: .normal)
                    
                }
                alert.view.tintColor = UIColor.label
                alert.addAction(cancelAction)
                alert.addAction(deleteAction)
                present(alert, animated: true)
            }
        } else {
            let alert = UIAlertController(title: "Already saved", message: "Do you want to delete it?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default)
            let deleteAction = UIAlertAction(title: "Delete", style: .default) { action in
                RealmDataManager.shared.deleteMedia(id: self.movieID)
                self.saveButtonOutlet.setImage(UIImage(systemName: "bookmark"), for: .normal)
                self.saveButtonOutlet.setTitle("save", for: .normal)
            }
            alert.view.tintColor = UIColor.label
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            present(alert, animated: true)
        }
    }
    
    
    func loadMediaDetails() {
        if let media = media {
            if let backdropPath = media.backdropPath {
                self.backdropPoster.sd_setImage(with: URL(string: K.baseImageUrl + (backdropPath)))
            } else { return }
            let url = K.baseUrl + K.getMovieByID + String(media.id!) + K.apiKey
            AF.request(url).responseData { response in
                do {
                    if let allData = try JSONDecoder().decode(MediaDetails?.self, from: response.data!) {
                        self.detailMedia = allData
                    }
                } catch {
                    print(error)
                }
            }
        } else { return }
    }
}


