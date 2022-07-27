//
//  SearchTableViewCell.swift
//  The Movie Database
//
//  Created by Beavean on 18.07.2022.
//

import UIKit
import SDWebImage


class MediaSearchTableviewCell: UITableViewCell {
    @IBOutlet weak var mediaPosterImageView: UIImageView!
    @IBOutlet weak var mediaTitleLabel: UILabel!
    @IBOutlet weak var mediaOverviewLabel: UILabel!
    @IBOutlet weak var mediaReleaseDateLabel: UILabel!
    @IBOutlet weak var mediaGenresLabel: UILabel!
    @IBOutlet weak var mediaRatingLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mediaPosterImageView.layer.cornerRadius = mediaPosterImageView.frame.width / 6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(with model: MoviesSearch.Results) {
        if let posterPath = model.posterPath {
            self.mediaPosterImageView.sd_setImage(with: URL(string: K.baseImageUrl + posterPath))
        }
        self.mediaTitleLabel.text = (model.title ?? "").isEmpty == false ? model.title : model.name
        self.mediaOverviewLabel.text = model.overview
        self.mediaGenresLabel.text = GenresDecoder.shared.decodeMovieGenreIDs(idNumbers: model.genreIDs!)
        self.mediaReleaseDateLabel.text = (model.releaseDate ?? "").isEmpty == false ? MediaDateFormatter.shared.formatDate(from: model.releaseDate ?? "") : MediaDateFormatter.shared.formatDate(from: model.firstAirDate ?? "")
        self.mediaRatingLabel.text = String(format: "%.1f", model.voteAverage!)


    }
    
    func configure(withRealm results: MediaRealm) {
        self.mediaPosterImageView.sd_setImage(with: URL(string: K.baseImageUrl + results.posterPath))
        self.mediaTitleLabel.text = results.title
        self.mediaOverviewLabel.text = results.overview
        self.mediaGenresLabel.text = results.genreIDs
        self.mediaReleaseDateLabel.text = results.releaseDate
        self.mediaRatingLabel.text = String(format: "%.1f", results.voteAverage)

    }
    
}
