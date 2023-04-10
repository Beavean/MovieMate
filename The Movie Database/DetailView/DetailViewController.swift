//
//  DetailViewController.swift
//  The Movie Database
//
//  Created by Beavean on 20.07.2022.
//

import SafariServices
import SDWebImage
import UIKit
import youtube_ios_player_helper

final class DetailViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet private var playerView: YTPlayerView!
    @IBOutlet private var mediaBackdropPosterImageView: UIImageView!
    @IBOutlet private var saveButton: UIButton!
    @IBOutlet private var mediaTitleLabel: UILabel!
    @IBOutlet private var mediaReleaseDateLabel: UILabel!
    @IBOutlet private var mediaGenresLabel: UILabel!
    @IBOutlet private var mediaPosterImageView: UIImageView!
    @IBOutlet private var mediaOverviewLabel: UILabel!
    @IBOutlet private var mediaRatingLabel: UILabel!
    @IBOutlet private var mediaVotesCountLabel: UILabel!
    @IBOutlet private var mediaBackgroundBlurImageView: UIImageView!
    @IBOutlet private var mediaTaglineLabel: UILabel!
    @IBOutlet private var mediaRuntimeLabel: UILabel!

    // MARK: - Properties

    var mediaID: Int?
    var mediaType: String?
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
        saveButtonPressed(button: saveButton, mediaID: mediaID, mediaType: mediaType)
    }

    @IBAction func openTMDBPageButtonPressed() {
        guard let openingUrl = URL(string: Constants.Network.movieDatabaseMainUrl) else { return }
        var resultUrl: URL?
        if let mediaID = mediaID, let mediaType = mediaType {
            guard let convertedUrl = URL(string: Constants.Network.movieDatabaseMainUrl + mediaType + "/" + String(describing: mediaID)) else { return }
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
            viewController.mediaType = mediaType
            navigationController?.pushViewController(viewController, animated: true)
        }
    }

    // MARK: - Completions to run after model receives data

    private func setupCompletions() {
        showLoader(true)
        viewModel.mediaType = mediaType
        viewModel.mediaID = mediaID
        viewModel.onDataUpdated = { [weak self] in
            self?.receivedDetails = self?.viewModel.mediaDetails
            self?.configureWithMediaDetails(model: self?.viewModel.mediaDetails)
            self?.loadVideoPlayer(videoKey: self?.viewModel.mediaVideoKey)
            self?.showLoader(false)
        }
    }

    // MARK: - Configuring all UI from media details

    func configureWithMediaDetails(model: MediaDetails?) {
        guard let model = model else { return }
        if let backdropPath = model.backdropPath {
            mediaBackdropPosterImageView.sd_setImage(with: URL(string: Constants.Network.baseImageUrl + backdropPath), placeholderImage: UIImage(systemName: Constants.UI.emptyPosterImage))
        } else {
            mediaBackdropPosterImageView.isHidden = true
        }
        if let posterPath = model.posterPath {
            mediaPosterImageView.sd_setImage(with: URL(string: Constants.Network.baseImageUrl + posterPath), placeholderImage: UIImage(systemName: Constants.UI.emptyPosterImage))
            mediaBackgroundBlurImageView.sd_setImage(with: URL(string: Constants.Network.baseImageUrl + posterPath), placeholderImage: UIImage(systemName: Constants.UI.emptyPosterImage))
        } else {
            mediaPosterImageView.image = UIImage(systemName: Constants.UI.emptyPosterImage)
            mediaBackgroundBlurImageView.image = UIImage(systemName: Constants.UI.emptyPosterImage)
        }
        mediaTaglineLabel.text = model.tagline
        mediaTitleLabel.text = model.title ?? model.name
        mediaOverviewLabel.text = model.overview
        mediaGenresLabel.text = model.convertGenresIntoString()
        mediaReleaseDateLabel.text = model.formatDate()
        mediaRatingLabel.text = String(format: "%.1f", model.voteAverage ?? 0.0)
        mediaVotesCountLabel.text = "\(String(describing: model.voteCount ?? 0)) votes"
        mediaRuntimeLabel.text = model.convertTimeDuration() ?? model.convertSeasonsAndEpisodes()
        saveButton.changeImageIfSaved(condition: RealmObjectManager.shared.checkIfAlreadySaved(id: model.id))
    }

    private func loadVideoPlayer(videoKey: String?) {
        guard let mediaVideoKey = videoKey else {
            playerView.isHidden = true
            return
        }
        playerView.load(withVideoId: mediaVideoKey, playerVars: ["playsinline": 1])
    }
}
