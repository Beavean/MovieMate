//
//  SeriesSearch.swift
//  The Movie Database
//
//  Created by Beavean on 19.07.2022.
//

import Foundation

struct SeriesSearch: Codable {
	let page: Int?
	let results: [Results]?
	let totalPages: Int?
	let totalResults: Int?

	enum CodingKeys: String, CodingKey {

		case page = "page"
		case results = "results"
		case totalPages = "total_pages"
		case totalResults = "total_results"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		page = try values.decodeIfPresent(Int.self, forKey: .page)
		results = try values.decodeIfPresent([Results].self, forKey: .results)
		totalPages = try values.decodeIfPresent(Int.self, forKey: .totalPages)
		totalResults = try values.decodeIfPresent(Int.self, forKey: .totalResults)
	}
    
    struct Results: Codable {
        let backdropPath: String?
        let firstAirDate: String?
        let genreIDs: [Int]?
        let id: Int?
        let name: String?
        let originCountry: [String]?
        let originalLanguage: String?
        let originalName: String?
        let overview: String?
        let popularity: Double?
        let posterPath: String?
        let voteAverage: Double?
        let voteCount: Int?

        enum CodingKeys: String, CodingKey {

            case backdropPath = "backdrop_path"
            case firstAirDate = "first_air_date"
            case genreIDs = "genre_ids"
            case id = "id"
            case name = "name"
            case originCountry = "origin_country"
            case originalLanguage = "original_language"
            case originalName = "original_name"
            case overview = "overview"
            case popularity = "popularity"
            case posterPath = "poster_path"
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            backdropPath = try values.decodeIfPresent(String.self, forKey: .backdropPath)
            firstAirDate = try values.decodeIfPresent(String.self, forKey: .firstAirDate)
            genreIDs = try values.decodeIfPresent([Int].self, forKey: .genreIDs)
            id = try values.decodeIfPresent(Int.self, forKey: .id)
            name = try values.decodeIfPresent(String.self, forKey: .name)
            originCountry = try values.decodeIfPresent([String].self, forKey: .originCountry)
            originalLanguage = try values.decodeIfPresent(String.self, forKey: .originalLanguage)
            originalName = try values.decodeIfPresent(String.self, forKey: .originalName)
            overview = try values.decodeIfPresent(String.self, forKey: .overview)
            popularity = try values.decodeIfPresent(Double.self, forKey: .popularity)
            posterPath = try values.decodeIfPresent(String.self, forKey: .posterPath)
            voteAverage = try values.decodeIfPresent(Double.self, forKey: .voteAverage)
            voteCount = try values.decodeIfPresent(Int.self, forKey: .voteCount)
        }

    }


}
