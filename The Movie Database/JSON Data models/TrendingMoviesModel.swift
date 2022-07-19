

import Foundation

struct TrendingMovies : Codable {
	let page : Int?
	let results : [Results]?
	let totalPages : Int?
	let totalResults : Int?

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
        let adult: Bool?
        let backdropPath: String?
        let genreIDs: [Int]?
        let id: Int?
        let mediaType: String?
        let title: String?
        let originalLanguage: String?
        let originalTitle: String?
        let overview: String?
        let popularity: Double?
        let posterPath: String?
        let releaseDate: String?
        let video: Bool?
        let voteAverage: Double?
        let voteCount: Int?

        enum CodingKeys: String, CodingKey {

            case adult = "adult"
            case backdropPath = "backdrop_path"
            case genreIDs = "genre_ids"
            case id = "id"
            case mediaType = "media_type"
            case title = "title"
            case originalLanguage = "original_language"
            case originalTitle = "original_title"
            case overview = "overview"
            case popularity = "popularity"
            case posterPath = "poster_path"
            case releaseDate = "release_date"
            case video = "video"
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            adult = try values.decodeIfPresent(Bool.self, forKey: .adult)
            backdropPath = try values.decodeIfPresent(String.self, forKey: .backdropPath)
            genreIDs = try values.decodeIfPresent([Int].self, forKey: .genreIDs)
            id = try values.decodeIfPresent(Int.self, forKey: .id)
            mediaType = try values.decodeIfPresent(String.self, forKey: .mediaType)
            title = try values.decodeIfPresent(String.self, forKey: .title)
            originalLanguage = try values.decodeIfPresent(String.self, forKey: .originalLanguage)
            originalTitle = try values.decodeIfPresent(String.self, forKey: .originalTitle)
            overview = try values.decodeIfPresent(String.self, forKey: .overview)
            popularity = try values.decodeIfPresent(Double.self, forKey: .popularity)
            posterPath = try values.decodeIfPresent(String.self, forKey: .posterPath)
            releaseDate = try values.decodeIfPresent(String.self, forKey: .releaseDate)
            video = try values.decodeIfPresent(Bool.self, forKey: .video)
            voteAverage = try values.decodeIfPresent(Double.self, forKey: .voteAverage)
            voteCount = try values.decodeIfPresent(Int.self, forKey: .voteCount)
        }

    }


}
