//
//  VideoViewCell.swift
//  The Movie Database
//
//  Created by Beavean on 13.08.2022.
//

import UIKit
import youtube_ios_player_helper

class VideoViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var videoPlayer: YTPlayerView!
    @IBOutlet weak var videoTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
