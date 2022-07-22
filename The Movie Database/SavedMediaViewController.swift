//
//  SavedMediaViewController.swift
//  The Movie Database
//
//  Created by Beavean on 21.07.2022.
//

import UIKit

class SavedMediaViewController: UIViewController {
    
    @IBOutlet weak var savedMediaTableView: UITableView!
    
    var arrayOfMedia: [MovieRealm] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savedMediaTableView.dataSource = self
        savedMediaTableView.delegate = self
        
        savedMediaTableView.register(UINib(nibName: K.MoviesCellReuseID, bundle: nil), forCellReuseIdentifier: K.MoviesCellReuseID)


        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getSavedMedia()
        savedMediaTableView.reloadData()
    }

    func getSavedMedia() {
        arrayOfMedia = RealmDataManager.shared.getMedia()
 
    }
}

extension SavedMediaViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayOfMedia.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.arrayOfMedia.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else {
            return
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: K.MoviesCellReuseID, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        let item = arrayOfMedia[indexPath.row]
        cell.configure(withRealm: item)
        return cell
    }
    
    
}

extension SavedMediaViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: K.DetailViewControllerID) as? DetailViewController {
            let media = self.arrayOfMedia[indexPath.row]
            viewController.movieID = self.arrayOfMedia[indexPath.row].id
            viewController.loadView()
            viewController.configureViewController(with: media)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
}
