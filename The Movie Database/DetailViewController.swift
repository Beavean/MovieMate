//
//  DetailViewController.swift
//  The Movie Database
//
//  Created by Beavean on 20.07.2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var backdropPoster: UIImageView!
    
    var movieID = Int()
    var backdropPosterPath = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewController()
      
    }
    
    func configureViewController() {
        self.backdropPoster.sd_setImage(with: URL(string: K.baseImageUrl + backdropPosterPath))
    }

}
