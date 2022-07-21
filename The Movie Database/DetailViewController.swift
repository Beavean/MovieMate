//
//  DetailViewController.swift
//  The Movie Database
//
//  Created by Beavean on 20.07.2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var backdropPoster: UIImageView!
    
    var searchIndex = Int()
    var movieID = Int()
    var backdropPosterPath: String? = nil
    var media: MoviesSearch.Results? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewController()
        
    }
    
    func configureViewController() {
        if let backdrop = backdropPosterPath {
            self.backdropPoster.sd_setImage(with: URL(string: K.baseImageUrl + backdrop))
        } else {
            return
        }
    }
}
