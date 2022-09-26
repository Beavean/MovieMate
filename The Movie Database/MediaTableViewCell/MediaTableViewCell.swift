//
//  MediaTableViewCell.swift
//  The Movie Database
//
//  Created by Beavean on 18.07.2022.
//

import Foundation
import SDWebImage

class MediaTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var saveButton: UIButton!
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
    
    //MARK: - Variables
    
    var mediaType: String?
    var saveButtonCompletion: ((UITableViewCell) -> Void)?
    var videoButtonCompletion: (() -> ()) = {}
    private var mediaID: Int?
    var receivedMedia: BasicMedia.Results? {
        didSet { configureWithReceivedMedia() }
    }
    var savedMedia: RealmObjectModel? {
        didSet { configureWithSavedMedia() }
    }
    
    //MARK: - TableViewCell lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mediaBackdropImageView.applyBlurEffect()
        mediaRatingBackgroundView.addSmallCornerRadius()
        mediaCellMainView.addSmallCornerRadius()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.mediaPosterImageView.image = UIImage(systemName: Constants.UI.emptyPosterImage)
    }
    
    //MARK: - Button interactions
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        saveButtonCompletion?(self)
    }
    
    @IBAction func videoButtonPressed(_ sender: UIButton) {
        videoButtonCompletion()
    }
    
    
    //MARK: - Configure cell with JSON model
    
    func configureWithReceivedMedia() {
        guard let model = receivedMedia else { return }
        if let id = model.id {
            saveButton.changeImageIfSaved(condition: RealmObjectManager.shared.checkIfAlreadySaved(id: id))
        }
        if let posterPath = model.posterPath {
            self.mediaPosterImageView.sd_setImage(with: URL(string: Constants.Network.baseImageUrl + posterPath), placeholderImage: UIImage(systemName: Constants.UI.emptyPosterImage))
        } else {
            self.mediaPosterImageView.image = UIImage(systemName: Constants.UI.emptyPosterImage)
        }
        if let backdropPath = model.backdropPath {
            self.mediaBackdropImageView.sd_setImage(with: URL(string: Constants.Network.baseImageUrl + backdropPath), placeholderImage: UIImage(systemName: Constants.UI.emptyPosterImage))
        } else {
            self.mediaBackdropImageView.image = UIImage(systemName: Constants.UI.emptyPosterImage)
        }
        self.mediaTitleLabel.text = model.title ?? model.name
        self.mediaOverviewLabel.text = model.overview
        self.mediaVotesCountLabel.text = String(describing: (model.voteCount ?? 0))
        self.mediaGenresLabel.text = MediaGenresDecoder.shared.decodeMovieGenreIDs(idNumbers: (model.genreIDs ?? []))
        self.mediaReleaseDateLabel.text = MediaDateFormatter.shared.formatDate(from: model.releaseDate ?? model.firstAirDate)
        self.mediaRatingLabel.text = String(format: "%.1f", (model.voteAverage ?? 0.0))
    }
    
    //MARK: - Configure cell with Realm object model
    
    func configureWithSavedMedia() {
        guard let object = savedMedia else { return }
        saveButton.changeImageIfSaved(condition: RealmObjectManager.shared.checkIfAlreadySaved(id: object.id))
        self.mediaType = object.mediaType
        if let posterPath = object.posterPath {
            self.mediaPosterImageView.sd_setImage(with: URL(string: Constants.Network.baseImageUrl + posterPath), placeholderImage: UIImage(systemName: Constants.UI.emptyPosterImage))
        } else {
            self.mediaPosterImageView.image = UIImage(systemName: Constants.UI.emptyPosterImage)
        }
        if let backdropPath = object.backdropPath {
            self.mediaBackdropImageView.sd_setImage(with: URL(string: Constants.Network.baseImageUrl + backdropPath), placeholderImage: UIImage(systemName: Constants.UI.emptyPosterImage))
        } else {
            self.mediaBackdropImageView.image = UIImage(systemName: Constants.UI.emptyPosterImage)
        }
        self.mediaVotesCountLabel.text = String(describing: object.voteCount ?? 0)
        self.mediaTitleLabel.text = object.title ?? "No title"
        self.mediaOverviewLabel.text = object.overview ?? "No overview"
        self.mediaGenresLabel.text = object.genreIDs ?? "Genre is not specified"
        self.mediaReleaseDateLabel.text = object.releaseDate ?? "No release date"
        self.mediaRatingLabel.text = String(format: "%.1f", object.voteAverage ?? 0.0)
    }
}



