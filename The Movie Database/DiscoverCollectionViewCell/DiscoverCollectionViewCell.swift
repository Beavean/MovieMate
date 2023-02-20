//
//  DiscoverCollectionViewCell.swift
//  The Movie Database
//
//  Created by Beavean on 06.08.2022.
//

import SDWebImage
import UIKit

final class DiscoverCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var posterImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.addSmallCornerRadius()
    }

    func configure(with model: MediaDetails) {
        if let posterPath = model.posterPath {
            posterImageView.sd_setImage(with: URL(string: Constants.Network.baseImageUrl + posterPath))
        } else {
            posterImageView.image = UIImage(systemName: Constants.UI.emptyPosterImage)
        }
    }
}
