//
//  MoviesSearch.swift
//  The Movie Database
//
//  Created by Beavean on 19.07.2022.
//

import Foundation

struct MediaSearch: Codable {
    
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
    
    struct Results: Codable {
        
        let adult: Bool?
        let backdropPath: String?
        let genreIDs: [Int]?
        let id: Int?
        let originalLanguage: String?
        let originalTitle: String?
        let overview: String?
        let popularity: Double?
        let posterPath: String?
        let releaseDate: String?
        let title: String?
        let video: Bool?
        let voteAverage: Double?
        let voteCount: Int?
        let firstAirDate: String?
        let name: String?
        let originalName: String?
        
        enum CodingKeys: String, CodingKey {
            case adult = "adult"
            case backdropPath = "backdrop_path"
            case genreIDs = "genre_ids"
            case id = "id"
            case originalLanguage = "original_language"
            case originalTitle = "original_title"
            case overview = "overview"
            case popularity = "popularity"
            case posterPath = "poster_path"
            case releaseDate = "release_date"
            case title = "title"
            case video = "video"
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
            case name = "name"
            case originalName = "original_name"
            case firstAirDate = "first_air_date"
        }
    }
}
