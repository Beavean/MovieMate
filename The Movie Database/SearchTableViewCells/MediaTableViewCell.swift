//
//  MediaTableViewCell.swift
//  The Movie Database
//
//  Created by Beavean on 18.07.2022.
//

import UIKit
import SDWebImage
import RealmSwift

class MediaTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var mediaPosterImageView: UIImageView!
    @IBOutlet private weak var mediaTitleLabel: UILabel!
    @IBOutlet private weak var mediaOverviewLabel: UILabel!
    @IBOutlet private weak var mediaReleaseDateLabel: UILabel!
    @IBOutlet private weak var mediaGenresLabel: UILabel!
    @IBOutlet private weak var mediaRatingLabel: UILabel!
    @IBOutlet private weak var mediaVotesCountLabel: UILabel!
    @IBOutlet private weak var mediaBackdropImageView: UIImageView!
    @IBOutlet private weak var mediaCellMainView: UIView!
    @IBOutlet private weak var mediaRatingBackgroundView: UIView!
    @IBOutlet private weak var saveButton: UIButton!
    
    var mediaID: Int? = nil
    var mediaType: String? = nil
    
    //MARK: - TableViewCell lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mediaBackdropImageView.alpha = 0.5
        mediaBackdropImageView.applyBlurEffect()
        mediaRatingBackgroundView.layer.cornerRadius = mediaRatingBackgroundView.frame.height * Constants.UI.cornerRadiusRatio
    }
    
    //MARK: - Configure cell with JSON model
    
    func configure(with model: MediaSearch.Results) {
        self.mediaID = model.id
        if let posterPath = model.posterPath {
            self.mediaPosterImageView.sd_setImage(with: URL(string: Constants.Network.baseImageUrl + posterPath))
        }
        if let backdropPath = model.backdropPath {
            self.mediaBackdropImageView.sd_setImage(with: URL(string: Constants.Network.baseImageUrl + backdropPath))
        }
        self.mediaTitleLabel.text = (model.title ?? "").isEmpty == false ? model.title : model.name
        self.mediaOverviewLabel.text = model.overview
        self.mediaVotesCountLabel.text = String(describing: model.voteCount!)
        self.mediaGenresLabel.text = MediaGenresDecoder.shared.decodeMovieGenreIDs(idNumbers: model.genreIDs!)
        self.mediaReleaseDateLabel.text = (model.releaseDate ?? "").isEmpty == false ? MediaDateFormatter.shared.formatDate(from: model.releaseDate ?? "") : MediaDateFormatter.shared.formatDate(from: model.firstAirDate ?? "")
        self.mediaRatingLabel.text = String(format: "%.1f", model.voteAverage!)
    }
    
    //MARK: - Configure cell with Realm object
    
    func configure(with object: MediaRealm) {
        self.mediaID = object.id
        self.mediaType = object.mediaType
        self.mediaPosterImageView.sd_setImage(with: URL(string: Constants.Network.baseImageUrl + object.posterPath))
        self.mediaBackdropImageView.sd_setImage(with: URL(string: Constants.Network.baseImageUrl + object.backdropPath))
        self.mediaVotesCountLabel.text = String(describing: object.voteCount)
        self.mediaTitleLabel.text = object.title
        self.mediaOverviewLabel.text = object.overview
        self.mediaGenresLabel.text = object.genreIDs
        self.mediaReleaseDateLabel.text = object.releaseDate
        self.mediaRatingLabel.text = String(format: "%.1f", object.voteAverage)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        SaveButtonManager.shared.savePressed(sender: saveButton, mediaID: mediaID, mediaType: mediaType)
    }
}

extension UIImageView {
    func applyBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
}

