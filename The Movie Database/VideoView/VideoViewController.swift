//
//  VideoViewController.swift
//  The Movie Database
//
//  Created by Beavean on 13.08.2022.
//

import UIKit
import youtube_ios_player_helper

class VideoViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var videoInfoLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var videosTableView: UITableView!
    
    //MARK: - Variables
    
    var mediaID: Int?
    var mediaType: String?
    var receivedDetails: [MediaVideos.Video]?
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
    
    //MARK: - Model completions setup & self configuration
    
    func setupCompletions() {
        showLoader(true)
        viewModel.mediaType = self.mediaType
        viewModel.mediaID = self.mediaID
        viewModel.onDataUpdated = { [weak self] in
            self?.receivedDetails = self?.viewModel.videoDetails
            self?.videosTableView.reloadData()
            self?.showLoader(false)
        }
    }
    
    func configureTitle(title: String?) {
        self.mediaTitle = title ?? "No title available"
    }
}
