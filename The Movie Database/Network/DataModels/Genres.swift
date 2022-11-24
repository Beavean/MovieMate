//
//  Genres.swift
//  The Movie Database
//
//  Created by Beavean on 24.11.2022.
//

import Foundation

struct Genres: Codable {

    let id: Int?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}
