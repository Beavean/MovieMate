//
//  DiscoverCollectionViewCell.swift
//  The Movie Database
//
//  Created by Beavean on 06.08.2022.
//

import UIKit
import SDWebImage

final class DiscoverCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets

    @IBOutlet private weak var posterImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.addSmallCornerRadius()
    }

    func configure(with model: BasicMedia.Results) {
        if let posterPath = model.posterPath {
            self.posterImageView.sd_setImage(with: URL(string: Constants.Network.baseImageUrl + posterPath))
        } else {
            self.posterImageView.image = UIImage(systemName: Constants.UI.emptyPosterImage)
        }
    }
}
