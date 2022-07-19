//
//  ViewController.swift
//  The Movie Database
//
//  Created by Beavean on 11.07.2022.
//

import UIKit
import SDWebImage
import Alamofire

class ViewController: UIViewController {
    
    
    var moviesArray = [TrendingMoviesResults]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = Constants.baseUrl + Constants.apiKey
        AF.request(url).responseJSON { response in
            do {
                if let allData = try JSONDecoder().decode(TrendingMovies?.self, from: response.data!) {
                    self.moviesArray = allData.results!
                    print(Constants.baseImageUrl + (self.moviesArray.last?.poster_path)!)
                }
            } catch {
                print(error)
            }
        }
    }
}



