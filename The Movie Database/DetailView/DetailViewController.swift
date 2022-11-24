//
//  DetailViewController.swift
//  The Movie Database
//
//  Created by Beavean on 20.07.2022.
//

import UIKit
import SDWebImage
import youtube_ios_player_helper
import SafariServices

final class DetailViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private var playerView: YTPlayerView!
    @IBOutlet private weak var mediaBackdropPosterImageView: UIImageView!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var mediaTitleLabel: UILabel!
    @IBOutlet private weak var mediaReleaseDateLabel: UILabel!
    @IBOutlet private weak var mediaGenresLabel: UILabel!
    @IBOutlet private weak var mediaPosterImageView: UIImageView!
    @IBOutlet private weak var mediaOverviewLabel: UILabel!
    @IBOutlet private weak var mediaRatingLabel: UILabel!
    @IBOutlet private weak var mediaVotesCountLabel: UILabel!
    @IBOutlet private weak var mediaBackgroundBlurImageView: UIImageView!
    @IBOutlet private weak var mediaTaglineLabel: UILabel!
    @IBOutlet private weak var mediaRuntimeLabel: UILabel!

    // MARK: - Properties

    var mediaID: Int?
    var mediaType: String?
    private var mediaVideoKey: String?
    private var viewModel: DetailViewModeling = DetailViewModel()
    private var receivedDetails: MediaDetails?

    // MARK: - DetailViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCompletions()
        viewModel.updateData()
        configureWithMediaDetails(model: receivedDetails)
        mediaPosterImageView.addSmallCornerRadius()
        mediaBackgroundBlurImageView.applyBlurEffect()
        mediaBackgroundBlurImageView.addSmallCornerRadius()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateData()
        configureWithMediaDetails(model: receivedDetails)
    }

    // MARK: - Button interactions

    @IBAction func saveButtonPressed() {
        self.saveButtonPressed(button: saveButton, mediaID: mediaID, mediaType: mediaType)
    }

    @IBAction func openTMDBPageButtonPressed() {
        guard let openingUrl = URL(string: Constants.Network.movieDatabaseMainUrl) else { return }
        var resultUrl: URL?
        if let mediaID = mediaID, let mediaType = mediaType {
            guard let convertedUrl = URL(string: Constants.Network.movieDatabaseMainUrl + mediaType + "/" + (String(describing: (mediaID)))) else { return }
            resultUrl = convertedUrl
        }
        let safariVC = SFSafariViewController(url: resultUrl ?? openingUrl)
        DispatchQueue.main.async {
            self.present(safariVC, animated: true)
        }
    }

    @IBAction func openVideosPressed() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: Constants.UI.videoViewControllerID) as? VideoViewController {
            viewController.configureTitle(title: receivedDetails?.title ?? receivedDetails?.originalName)
            viewController.mediaID = mediaID
            viewController.mediaType = self.mediaType
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    // MARK: - Completions to run after model receives data

    private func setupCompletions() {
        showLoader(true)
        viewModel.mediaType = self.mediaType
        viewModel.mediaID = self.mediaID
        viewModel.onDataUpdated = { [weak self] in
            self?.receivedDetails = self?.viewModel.mediaDetails
            self?.mediaVideoKey = self?.viewModel.mediaVideoKey
            self?.configureWithMediaDetails(model: self?.viewModel.mediaDetails)
            self?.loadVideoPlayer(videoKey: self?.viewModel.mediaVideoKey)
            self?.showLoader(false)
        }
    }

    // MARK: - Configuring all UI from media details

    func configureWithMediaDetails(model: MediaDetails?) {
        guard let model = model else { return }
        if let backdropPath = model.backdropPath {
            self.mediaBackdropPosterImageView.sd_setImage(with: URL(string: Constants.Network.baseImageUrl + backdropPath), placeholderImage: UIImage(systemName: Constants.UI.emptyPosterImage))
        } else {
            self.mediaBackdropPosterImageView.isHidden = true
        }
        if let posterPath = model.posterPath {
            self.mediaPosterImageView.sd_setImage(with: URL(string: Constants.Network.baseImageUrl + posterPath), placeholderImage: UIImage(systemName: Constants.UI.emptyPosterImage))
            self.mediaBackgroundBlurImageView.sd_setImage(with: URL(string: Constants.Network.baseImageUrl + posterPath), placeholderImage: UIImage(systemName: Constants.UI.emptyPosterImage))
        } else {
            self.mediaPosterImageView.image = UIImage(systemName: Constants.UI.emptyPosterImage)
            self.mediaBackgroundBlurImageView.image = UIImage(systemName: Constants.UI.emptyPosterImage)
        }
        self.mediaTaglineLabel.text = model.tagline
        self.mediaTitleLabel.text = model.title ?? model.name
        self.mediaOverviewLabel.text = model.overview
        self.mediaGenresLabel.text = model.convertGenresIntoString()
        self.mediaReleaseDateLabel.text = MediaDateFormatter.shared.formatDate(from: model.firstAirDate ?? model.releaseDate)
        self.mediaRatingLabel.text = String(format: "%.1f", (model.voteAverage ?? 0.0))
        self.mediaVotesCountLabel.text = "\(String(describing: (model.voteCount ?? 0))) votes"
        self.mediaRuntimeLabel.text = model.convertTimeDuration() ?? model.convertSeasonsAndEpisodes()
        self.saveButton.changeImageIfSaved(condition: RealmObjectManager.shared.checkIfAlreadySaved(id: model.id))
    }

    private func loadVideoPlayer(videoKey: String?) {
        guard let mediaVideoKey = videoKey else {
            self.playerView.isHidden = true
            return }
        self.playerView.load(withVideoId: mediaVideoKey, playerVars: ["playsinline": 1])
    }
}
