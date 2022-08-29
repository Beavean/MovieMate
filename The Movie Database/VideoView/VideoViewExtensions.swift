//
//  VideoViewExtensions.swift
//  The Movie Database
//
//  Created by Beavean on 21.08.2022.
//

import UIKit


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






