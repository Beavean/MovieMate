//
//  SavedViewController.swift
//  The Movie Database
//
//  Created by Beavean on 21.07.2022.
//

import RealmSwift
import UIKit

final class SavedViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var savedMediaTableView: UITableView!
    @IBOutlet private var savedMediaSearchBar: UISearchBar!

    var arrayOfMedia: Results<RealmObjectModel>? {
        didSet { savedMediaTableView.reloadData() }
    }

    private var lastScheduledSearch: Timer?
    private var viewModel: SavedViewModeling = SavedViewModel()

    // MARK: - SavedViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCompletions()
        viewModel.loadSavedMedia(searchText: savedMediaSearchBar.text)
        savedMediaTableView.dataSource = self
        savedMediaTableView.delegate = self
        savedMediaSearchBar.delegate = self
        savedMediaTableView.register(UINib(nibName: Constants.UI.mediaTableViewCellReuseID, bundle: nil), forCellReuseIdentifier: Constants.UI.mediaTableViewCellReuseID)
    }

    override func viewWillAppear(_: Bool) {
        savedMediaTableView.reloadData()
    }

    // MARK: - Model completion setup

    private func setupCompletions() {
        showLoader(true)
        viewModel.onDataUpdated = { [weak self] in
            guard let arrayOfMedia = self?.viewModel.arrayOfMedia else { return }
            self?.arrayOfMedia = arrayOfMedia
            self?.showLoader(false)
        }
    }
}

// MARK: - UITableViewDelegate

extension SavedViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Constants.UI.mainStoryboardName, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: Constants.UI.detailViewControllerID) as? DetailViewController, let media = arrayOfMedia?[indexPath.row] {
            viewController.mediaID = media.id
            viewController.mediaType = media.mediaType
            navigationController?.pushViewController(viewController, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let media = arrayOfMedia?[indexPath.row] else { return }
        if editingStyle == .delete {
            RealmObjectManager.shared.deleteMedia(id: media.id)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else {
            return
        }
    }
}

// MARK: - UITableViewDataSource

extension SavedViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        arrayOfMedia?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.UI.mediaTableViewCellReuseID, for: indexPath) as? MediaTableViewCell,
              let item = arrayOfMedia?[indexPath.row] else { return UITableViewCell() }
        cell.savedMedia = item
        cell.selectionStyle = .none
        cell.saveButtonCompletion = { aCell in
            guard let actualIndexPath = tableView.indexPath(for: aCell) else { return }
            self.saveButtonPressed(button: cell.saveButton, mediaID: item.id, mediaType: item.mediaType) { [weak self] in
                self?.savedMediaTableView.deleteRows(at: [actualIndexPath], with: .fade)
            }
        }
        cell.videoButtonCompletion = { [weak self] in
            if let viewController = self?.storyboard?.instantiateViewController(withIdentifier: Constants.UI.videoViewControllerID) as? VideoViewController {
                viewController.configureTitle(title: item.originalTitle)
                viewController.mediaID = item.id
                viewController.mediaType = item.mediaType
                self?.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        return cell
    }
}

// MARK: - UISearchBarDelegate

extension SavedViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        viewModel.loadSavedMedia(searchText: savedMediaSearchBar.text)
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }

    func searchBar(_: UISearchBar, textDidChange _: String) {
        lastScheduledSearch?.invalidate()
        lastScheduledSearch = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [weak self] _ in
            self?.viewModel.loadSavedMedia(searchText: self?.savedMediaSearchBar.text)
            self?.lastScheduledSearch?.invalidate()
        })
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.loadSavedMedia(searchText: savedMediaSearchBar.text)
        searchBar.text = ""
        searchBar.endEditing(true)
    }
}
