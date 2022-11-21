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
        case adult = "adult"
        case backdropPath = "backdrop_path"
        case budget = "budget"
        case genres = "genres"
        case homepage = "homepage"
        case id = "id"
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview = "overview"
        case popularity = "popularity"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case revenue = "revenue"
        case runtime = "runtime"
        case status = "status"
        case tagline = "tagline"
        case title = "title"
        case video = "video"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case firstAirDate = "first_air_date"
        case name = "name"
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case originalName = "original_name"
        case type = "type"
    }

    func convertGenresIntoString() -> String {
        guard let genres = genres else { return "Genre is not specified" }
        var resultString = "Genre is not specified"
        var decodingArray: [String] = []
        for genre in genres {
            guard let name = genre.name else { return "Genre is not specified" }
            decodingArray.append(name)
        }
        resultString = decodingArray.joined(separator: ", ")
        if resultString.isEmpty {
            return "Genre is not specified"
        } else {
            return resultString
        }
    }

    func convertTimeDuration() -> String? {
        guard let runtime = runtime else {
            return nil
        }
        let hours = runtime / 60
        let minutes = runtime - (hours * 60)
        switch hours {
        case 0: return "\(minutes) minutes"
        case 1: return "\(hours) hour \(minutes) minutes"
        default: return "\(hours) hours \(minutes) minutes"
        }
    }

    func convertSeasonsAndEpisodes() -> String? {
        let resultString: String
        if let numberOfSeasons = numberOfSeasons, let numberOfEpisodes = numberOfEpisodes {
            resultString = "Seasons: \(numberOfSeasons) \n Episodes: \(numberOfEpisodes)"
            return resultString
        }
        if let numberOfSeasons = numberOfSeasons {
            resultString = "Seasons: \(numberOfSeasons)"
            return resultString
        }
        if let numberOfEpisodes = numberOfEpisodes {
            resultString = "Episodes: \(numberOfEpisodes)"
            return resultString
        } else {
            return nil
        }
    }

    struct Genres: Codable {

        let id: Int?
        let name: String?

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case name = "name"
        }
    }
}
