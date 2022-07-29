//
//  MediaVideos.swift
//  The Movie Database
//
//  Created by Beavean on 26.07.2022.
//

import Foundation

struct MediaVideos: Codable {
    
    let id: Int?
    let results: [Results]?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case results = "results"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        results = try values.decodeIfPresent([Results].self, forKey: .results)
    }
    
    struct Results: Codable {
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
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            name = try values.decodeIfPresent(String.self, forKey: .name)
            key = try values.decodeIfPresent(String.self, forKey: .key)
            site = try values.decodeIfPresent(String.self, forKey: .site)
            size = try values.decodeIfPresent(Int.self, forKey: .size)
            type = try values.decodeIfPresent(String.self, forKey: .type)
            official = try values.decodeIfPresent(Bool.self, forKey: .official)
            publishedAt = try values.decodeIfPresent(String.self, forKey: .publishedAt)
            id = try values.decodeIfPresent(String.self, forKey: .id)
        }
    }
}
