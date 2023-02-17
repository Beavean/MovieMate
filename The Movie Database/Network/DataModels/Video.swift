//
//  Video.swift
//  The Movie Database
//
//  Created by Beavean on 24.11.2022.
//

import Foundation

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
        case name, key, site, size, type, official, id
        case publishedAt = "published_at"
    }
}
