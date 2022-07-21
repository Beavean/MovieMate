//
//  SavedMediaViewController.swift
//  The Movie Database
//
//  Created by Beavean on 21.07.2022.
//

import UIKit

class SavedMediaViewController: UIViewController {
    
    @IBOutlet weak var savedMediaTableView: UITableView!
    
    var arrayOgMedia: [MovieRealm] = []
    
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
        arrayOgMedia = RealmDataManager.shared.getMedia()
 
    }
}

extension SavedMediaViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayOgMedia.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: K.MoviesCellReuseID, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        let item = arrayOgMedia[indexPath.row]
        cell.configure(withRealm: item)
        return cell
    }
    
    
}

extension SavedMediaViewController: UITableViewDelegate {
    
}
