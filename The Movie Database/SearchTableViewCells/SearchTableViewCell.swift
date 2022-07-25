//
//  SearchTableViewCell.swift
//  The Movie Database
//
//  Created by Beavean on 18.07.2022.
//

import UIKit
import SDWebImage


class SearchTableViewCell: UITableViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var movieGenresLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.layer.cornerRadius = posterImageView.frame.width / 6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(withModel results: MoviesSearch.Results) {
        if let posterPath = results.posterPath {
            self.posterImageView.sd_setImage(with: URL(string: K.baseImageUrl + posterPath))
        }
        self.movieTitleLabel.text = (results.title ?? "").isEmpty == false ? results.title : results.name
        self.movieOverviewLabel.text = results.overview
        self.movieGenresLabel.text = GenresDecoder.shared.decodeMovieGenreIDs(idNumbers: results.genreIDs!)
        self.releaseDateLabel.text = (results.releaseDate ?? "").isEmpty == false ? MediaDateFormatter.shared.formatDate(from: results.releaseDate ?? "") : MediaDateFormatter.shared.formatDate(from: results.firstAirDate ?? "")
        self.ratingLabel.text = String(format: "%.1f", results.voteAverage!)


    }
    
    func configure(withRealm results: MovieRealm) {
        self.posterImageView.sd_setImage(with: URL(string: K.baseImageUrl + results.posterPath))
        self.movieTitleLabel.text = results.title
        self.movieOverviewLabel.text = results.overview
        self.movieGenresLabel.text = results.genreIDs
        self.releaseDateLabel.text = results.releaseDate
        self.ratingLabel.text = "\(results.voteAverage)"

    }
    
}
