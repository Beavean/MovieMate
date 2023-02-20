//
//  VideoViewCell.swift
//  The Movie Database
//
//  Created by Beavean on 13.08.2022.
//

import UIKit
import youtube_ios_player_helper

class VideoViewCell: UITableViewCell {
    // MARK: - IBOutlets

    @IBOutlet var videoPlayer: YTPlayerView!
    @IBOutlet var videoTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
