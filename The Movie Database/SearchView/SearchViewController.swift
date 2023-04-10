//
//  SearchViewController.swift
//  The Movie Database
//
//  Created by Beavean on 11.07.2022.
//

import UIKit

final class SearchViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var contentTypeSegmentedControl: UISegmentedControl!
    @IBOutlet var mediaTableView: UITableView!

    // MARK: - Properties

    var mediaSearchResults = [MediaDetails]() {
        didSet { mediaTableView.reloadData() }
    }

    var mediaType = Constants.Network.movieType
    private var lastScheduledSearch: Timer?
    private var viewModel: SearchViewModeling = SearchViewModel()

    // MARK: - SearchViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCompletions()
        viewModel.updateData()
        mediaTableView.dataSource = self
        mediaTableView.delegate = self
        searchBar.delegate = self
        mediaTableView.register(UINib(nibName: Constants.UI.mediaTableViewCellReuseID, bundle: nil), forCellReuseIdentifier: Constants.UI.mediaTableViewCellReuseID)
    }

    // MARK: - SegmentedControl interaction and reload media methods

    @IBAction func segmentedControlChanged() {
        viewModel.mediaTypeSegmentedControl = contentTypeSegmentedControl.selectedSegmentIndex
        loadSearchResults()
    }

    @objc private func loadSearchResults() {
        guard let enteredQuery = searchBar.searchTextField.text else { return }
        viewModel.enteredQuery = enteredQuery
        viewModel.updateData()
    }

    private func setupCompletions() {
        showLoader(true)
        viewModel.onDataUpdated = { [weak self] in
            guard let receivedMedia = self?.viewModel.mediaSearchResults,
                  let mediaType = self?.viewModel.mediaType,
                  let mediaTableView = self?.mediaTableView else { return }
            self?.mediaSearchResults = receivedMedia
            self?.mediaType = mediaType
            if mediaTableView.numberOfRows(inSection: 0) > 0 {
                mediaTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
            } else {
                return
            }
            self?.showLoader(false)
        }
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadSearchResults()
        searchBar.endEditing(true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadSearchResults()
        searchBar.text = ""
        searchBar.endEditing(true)
    }

    func searchBar(_: UISearchBar, textDidChange _: String) {
        lastScheduledSearch?.invalidate()
        lastScheduledSearch = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(loadSearchResults), userInfo: nil, repeats: false)
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Constants.UI.mainStoryboardName, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: Constants.UI.detailViewControllerID) as? DetailViewController,
           let mediaID = mediaSearchResults[indexPath.row].id {
            viewController.mediaID = mediaID
            viewController.mediaType = mediaType
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return mediaSearchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.UI.mediaTableViewCellReuseID, for: indexPath) as? MediaTableViewCell else { return UITableViewCell() }
        let item = mediaSearchResults[indexPath.row]
        cell.saveButtonCompletion = { _ in
            self.saveButtonPressed(button: cell.saveButton, mediaID: item.id, mediaType: self.mediaType) { [weak self] in
                DispatchQueue.main.async {
                    self?.mediaTableView.reloadData()
                }
            }
        }
        cell.videoButtonCompletion = { [weak self] in
            if let viewController = self?.storyboard?.instantiateViewController(withIdentifier: Constants.UI.videoViewControllerID) as? VideoViewController {
                viewController.configureTitle(title: item.originalTitle ?? item.originalName)
                viewController.mediaID = item.id
                viewController.mediaType = self?.mediaType
                self?.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        cell.receivedMedia = item
        cell.selectionStyle = .none
        return cell
    }
}
