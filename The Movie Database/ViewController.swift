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
    
    let apiKey = ""
    let baseUrl = "https://api.themoviedb.org/3/trending/movie/week?api_key="
    let cellSidesInset = 8.0
    
    var moviesArray = [Results]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = baseUrl + apiKey
        AF.request(url).responseJSON { response in
            do {
                if let allData = try JSONDecoder().decode(TrendingMovies?.self, from: response.data!) {
                    self.moviesArray = allData.results!
                }
                
            } catch {
                print(error)
            }
        }
        collectionView.contentInset = UIEdgeInsets(top: 0, left: cellSidesInset, bottom: 0, right: cellSidesInset)
    }
    override func viewDidLayoutSubviews() {
        
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.safeAreaLayoutGuide.layoutFrame.width - cellSidesInset * 2
        let height = view.safeAreaLayoutGuide.layoutFrame.height - cellSidesInset * 2
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        cellSidesInset * 2
    }
}


