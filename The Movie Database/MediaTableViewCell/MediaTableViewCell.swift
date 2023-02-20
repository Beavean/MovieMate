//
//  MediaTableViewCell.swift
//  The Movie Database
//
//  Created by Beavean on 18.07.2022.
//

import Foundation
import SDWebImage

final class MediaTableViewCell: UITableViewCell {
    // MARK: - IBOutlets

    @IBOutlet var saveButton: UIButton!
    @IBOutlet private var mediaPosterImageView: UIImageView!
    @IBOutlet private var mediaTitleLabel: UILabel!
    @IBOutlet private var mediaOverviewLabel: UILabel!
    @IBOutlet private var mediaReleaseDateLabel: UILabel!
    @IBOutlet private var mediaGenresLabel: UILabel!
    @IBOutlet private var mediaRatingLabel: UILabel!
    @IBOutlet private var mediaVotesCountLabel: UILabel!
    @IBOutlet private var mediaBackdropImageView: UIImageView!
    @IBOutlet private var mediaCellMainView: UIView!
    @IBOutlet private var mediaRatingBackgroundView: UIView!

    // MARK: - Properties

    var mediaType: String?
    var saveButtonCompletion: ((UITableViewCell) -> Void)?
    var videoButtonCompletion: (() -> Void) = {}
    var receivedMedia: MediaDetails? {
        didSet { configureWithReceivedMedia() }
    }

    var savedMedia: RealmObjectModel? {
        didSet { configureWithSavedMedia() }
    }

    private var mediaID: Int?

    // MARK: - TableViewCell lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        mediaBackdropImageView.applyBlurEffect()
        mediaRatingBackgroundView.addSmallCornerRadius()
        mediaCellMainView.addSmallCornerRadius()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        mediaPosterImageView.image = UIImage(systemName: Constants.UI.emptyPosterImage)
    }

    // MARK: - Button interactions

    @IBAction func saveButtonPressed() {
        saveButtonCompletion?(self)
    }

    @IBAction func videoButtonPressed() {
        videoButtonCompletion()
    }

    // MARK: - Configure cell with JSON model

    func configureWithReceivedMedia() {
        guard let model = receivedMedia else { return }
        if let id = model.id {
            saveButton.changeImageIfSaved(condition: RealmObjectManager.shared.checkIfAlreadySaved(id: id))
        }
        if let posterPath = model.posterPath {
            mediaPosterImageView.sd_setImage(with: URL(string: Constants.Network.baseImageUrl + posterPath), placeholderImage: UIImage(systemName: Constants.UI.emptyPosterImage))
        } else {
            mediaPosterImageView.image = UIImage(systemName: Constants.UI.emptyPosterImage)
        }
        if let backdropPath = model.backdropPath {
            mediaBackdropImageView.sd_setImage(with: URL(string: Constants.Network.baseImageUrl + backdropPath), placeholderImage: UIImage(systemName: Constants.UI.emptyPosterImage))
        } else {
            mediaBackdropImageView.image = UIImage(systemName: Constants.UI.emptyPosterImage)
        }
        mediaTitleLabel.text = model.title ?? model.name
        mediaOverviewLabel.text = model.overview
        mediaVotesCountLabel.text = String(describing: model.voteCount ?? 0)
        mediaGenresLabel.text = model.decodeMovieGenreIDs()
        mediaReleaseDateLabel.text = model.formatDate()
        mediaRatingLabel.text = String(format: "%.1f", model.voteAverage ?? 0.0)
    }

    // MARK: - Configure cell with Realm object model

    func configureWithSavedMedia() {
        guard let object = savedMedia else { return }
        saveButton.changeImageIfSaved(condition: RealmObjectManager.shared.checkIfAlreadySaved(id: object.id))
        mediaType = object.mediaType
        if let posterPath = object.posterPath {
            mediaPosterImageView.sd_setImage(with: URL(string: Constants.Network.baseImageUrl + posterPath), placeholderImage: UIImage(systemName: Constants.UI.emptyPosterImage))
        } else {
            mediaPosterImageView.image = UIImage(systemName: Constants.UI.emptyPosterImage)
        }
        if let backdropPath = object.backdropPath {
            mediaBackdropImageView.sd_setImage(with: URL(string: Constants.Network.baseImageUrl + backdropPath), placeholderImage: UIImage(systemName: Constants.UI.emptyPosterImage))
        } else {
            mediaBackdropImageView.image = UIImage(systemName: Constants.UI.emptyPosterImage)
        }
        mediaVotesCountLabel.text = String(describing: object.voteCount ?? 0)
        mediaTitleLabel.text = object.title ?? "No title"
        mediaOverviewLabel.text = object.overview ?? "No overview"
        mediaGenresLabel.text = object.genreIDs ?? "Genre is not specified"
        mediaReleaseDateLabel.text = object.releaseDate ?? "No release date"
        mediaRatingLabel.text = String(format: "%.1f", object.voteAverage ?? 0.0)
    }
}
