//
//  SavedMediaViewController.swift
//  The Movie Database
//
//  Created by Beavean on 21.07.2022.
//

import UIKit

class SavedMediaViewController: UIViewController {
    
    @IBOutlet private weak var savedMediaTableView: UITableView!
    
    var arrayOfMedia: [MediaRealm] = []
    
    //MARK: - SavedMediaViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savedMediaTableView.dataSource = self
        savedMediaTableView.delegate = self
        savedMediaTableView.register(UINib(nibName: Constants.UI.MoviesCellReuseID, bundle: nil), forCellReuseIdentifier: Constants.UI.MoviesCellReuseID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getSavedMedia()
        savedMediaTableView.reloadData()
    }
    
    func getSavedMedia() {
        arrayOfMedia = RealmDataManager.shared.getMedia()
    }
}

//MARK: - extension - Table View Data Source

extension SavedMediaViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayOfMedia.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            RealmDataManager.shared.deleteMedia(id: arrayOfMedia[indexPath.row].id)
            self.arrayOfMedia.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            savedMediaTableView.endUpdates()
        } else {
            return
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: Constants.UI.MoviesCellReuseID, for: indexPath) as? MediaTableViewCell else { return UITableViewCell() }
        let item = arrayOfMedia[indexPath.row]
        cell.configure(with: item)
        return cell
    }
}

//MARK: - extension - Table View Delegate

extension SavedMediaViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: Constants.UI.DetailViewControllerID) as? DetailViewController {
            let media = self.arrayOfMedia[indexPath.row]
            viewController.mediaID = self.arrayOfMedia[indexPath.row].id
            viewController.loadView()
            viewController.configureViewController(with: media)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
