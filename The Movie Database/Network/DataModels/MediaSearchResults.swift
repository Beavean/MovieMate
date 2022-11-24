//
//  MoviesSearch.swift
//  The Movie Database
//
//  Created by Beavean on 19.07.2022.
//

import Foundation

struct MediaSearchResults: Codable {

    let page: Int?
    let results: [MediaDetails]?
    let totalPages: Int?
    let totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
