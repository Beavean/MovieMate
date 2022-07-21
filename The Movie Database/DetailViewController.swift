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
    
    var searchIndex = Int()
    var movieID = Int()
    var backdropPosterPath: String? = nil
    var media: MoviesSearch.Results? = nil
    var detailMedia: MediaDetails? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewController()
        
    }
    
    func configureViewController() {
        if let media = media {
            if let backdropPath = media.backdropPath {
                self.backdropPoster.sd_setImage(with: URL(string: K.baseImageUrl + (backdropPath)))
            } else { return }
            let url = K.baseUrl + K.getMovieByID + String(media.id!) + K.apiKey
            AF.request(url).responseData { response in
                do {
                    if let allData = try JSONDecoder().decode(MediaDetails?.self, from: response.data!) {
                        self.detailMedia = allData
                        print(self.detailMedia!.budget!)
                    }
                } catch {
                    print(error)
                }
            }
        } else { return }
    }
}
