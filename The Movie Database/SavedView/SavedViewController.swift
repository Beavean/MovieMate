//
//  SavedViewController.swift
//  The Movie Database
//
//  Created by Beavean on 21.07.2022.
//

import UIKit

class SavedViewController: UIViewController {

    @IBOutlet weak var savedMediaTableView: UITableView!

    var arrayOfMedia: [RealmObjectModel] = []
    var viewModel: SavedViewModeling = SavedViewModel()

    //MARK: - SavedViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCompletions()
        viewModel.loadSavedMedia()
        savedMediaTableView.dataSource = self
        savedMediaTableView.delegate = self
        savedMediaTableView.register(UINib(nibName: Constants.UI.mediaTableViewCellReuseID, bundle: nil), forCellReuseIdentifier: Constants.UI.mediaTableViewCellReuseID)
        savedMediaTableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.loadSavedMedia()
        savedMediaTableView.reloadData()
    }

    func setupCompletions() {
        viewModel.onDataUpdated = { [weak self] in
            guard let arrayOfMedia = self?.viewModel.arrayOfMedia, let tableView = self?.savedMediaTableView else { return }
            self?.arrayOfMedia = arrayOfMedia
            tableView.reloadData()
        }
    }
}

