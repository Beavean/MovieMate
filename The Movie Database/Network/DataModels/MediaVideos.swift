//
//  MediaVideos.swift
//  The Movie Database
//
//  Created by Beavean on 26.07.2022.
//

import Foundation

struct MediaVideos: Codable {

    let id: Int?
    let results: [Video]?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case results = "results"
    }

    struct Video: Codable {
        let name: String?
        let key: String?
        let site: String?
        let size: Int?
        let type: String?
        let official: Bool?
        let publishedAt: String?
        let id: String?

        enum CodingKeys: String, CodingKey {
            case name = "name"
            case key = "key"
            case site = "site"
            case size = "size"
            case type = "type"
            case official = "official"
            case publishedAt = "published_at"
            case id = "id"
        }
    }
}
