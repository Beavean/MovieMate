//
//  VideoViewController.swift
//  The Movie Database
//
//  Created by Beavean on 13.08.2022.
//

import UIKit
import youtube_ios_player_helper
import SwiftUI

class VideoViewController: UIViewController {
    
    var mediaTitle: String?
    var mediaID: Int?
    var mediaType: String?
    var viewModel: VideoViewModeling = VideoViewModel()
    var receivedDetails: [MediaVideos.Video]?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var videosTableView: UITableView!
    @IBOutlet weak var videoInfoLabel: UILabel!
    
    
    override func viewDidLoad() {
        videosTableView.dataSource = self
        super.viewDidLoad()
        videosTableView.register(UINib(nibName: Constants.UI.videoViewCellID, bundle: nil), forCellReuseIdentifier: Constants.UI.videoViewCellID)
        setupCompletions()
        viewModel.updateData()
        titleLabel.text = mediaTitle
    }
    
    func setupCompletions() {
        viewModel.mediaType = self.mediaType
        viewModel.mediaID = self.mediaID
        viewModel.onDataUpdated = { [weak self] in
            self?.receivedDetails = self?.viewModel.videoDetails
            self?.videosTableView.reloadData()
        }
    }
    
    func configureTitle(title: String?) {
        if let title = title {
            self.mediaTitle = title
        } else {
            self.mediaTitle = "No title available"
        }
    }
}
