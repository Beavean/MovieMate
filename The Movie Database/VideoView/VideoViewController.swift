//
//  VideoViewController.swift
//  The Movie Database
//
//  Created by Beavean on 13.08.2022.
//

import UIKit
import youtube_ios_player_helper

final class VideoViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var videoInfoLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var videosTableView: UITableView!

    // MARK: - Properties

    var mediaID: Int?
    var mediaType: String?
    var receivedDetails: [Video]? {
        didSet { videosTableView.reloadData() }
    }
    private var viewModel: VideoViewModeling = VideoViewModel()
    private var mediaTitle: String?

    override func viewDidLoad() {
        videosTableView.dataSource = self
        super.viewDidLoad()
        videosTableView.register(UINib(nibName: Constants.UI.videoViewCellID, bundle: nil), forCellReuseIdentifier: Constants.UI.videoViewCellID)
        setupCompletions()
        viewModel.updateData()
        titleLabel.text = mediaTitle
    }

    // MARK: - Model completions setup & self configuration

    private func setupCompletions() {
        showLoader(true)
        viewModel.mediaType = self.mediaType
        viewModel.mediaID = self.mediaID
        viewModel.onDataUpdated = { [weak self] in
            self?.receivedDetails = self?.viewModel.videoDetails
            self?.showLoader(false)
        }
    }

    func configureTitle(title: String?) {
        self.mediaTitle = title ?? "No title available"
    }
}

// MARK: - UITableViewDataSource

extension VideoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let videos = receivedDetails else { return 0 }
        switch videos.count {
        case 0:
            self.videoInfoLabel.text = "No videos available ⚠️"
            return 0
        case 1:
            self.videoInfoLabel.text = "\(videos.count) video available:"
            return videos.count
        default:
            self.videoInfoLabel.text = "\(videos.count) videos available:"
            return videos.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.UI.videoViewCellID, for: indexPath) as? VideoViewCell, let videos = receivedDetails else { return UITableViewCell() }
        guard let videoKey = videos.reversed()[indexPath.row].key else { return UITableViewCell() }
        cell.videoPlayer.load(withVideoId: videoKey, playerVars: ["playsinline": 1])
        cell.videoTitleLabel.text = videos.reversed()[indexPath.row].name
        return cell
    }
}
