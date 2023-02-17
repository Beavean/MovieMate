//
//  MediaDetails.swift
//  The Movie Database
//
//  Created by Beavean on 21.07.2022.
//

import Foundation

struct MediaDetails: Codable {
    let adult: Bool?
    let backdropPath: String?
    let budget: Int?
    let genres: [Genres]?
    let genreIDs: [Int]?
    let homepage: String?
    let id: Int?
    let imdbID: String?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate: String?
    let revenue: Int?
    let runtime: Int?
    let status: String?
    let tagline: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let firstAirDate: String?
    let name: String?
    let numberOfEpisodes: Int?
    let numberOfSeasons: Int?
    let originalName: String?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case budget
        case genres
        case genreIDs = "genre_ids"
        case homepage
        case id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case revenue
        case runtime
        case status
        case tagline
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case firstAirDate = "first_air_date"
        case name
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case originalName = "original_name"
        case type
    }

    func convertGenresIntoString() -> String {
        let genreNotSpecified = "Genre is not specified"
        guard let genres = genres else { return genreNotSpecified }
        let decodingArray = genres.compactMap { $0.name }
        return decodingArray.isEmpty ? genreNotSpecified : decodingArray.joined(separator: ", ")
    }

    func convertTimeDuration() -> String? {
        guard let runtime = runtime else { return nil }
        let hours = runtime / 60
        let minutes = runtime - (hours * 60)
        switch hours {
        case 0: return "\(minutes) minutes"
        case 1: return "\(hours) hour \(minutes) minutes"
        default: return "\(hours) hours \(minutes) minutes"
        }
    }

    func convertSeasonsAndEpisodes() -> String? {
        let seasonsString = numberOfSeasons.map { "Seasons: \($0)" } ?? ""
        let episodesString = numberOfEpisodes.map { "Episodes: \($0)" } ?? ""
        return [seasonsString, episodesString].filter { !$0.isEmpty }.joined(separator: " \n ")
    }
}
