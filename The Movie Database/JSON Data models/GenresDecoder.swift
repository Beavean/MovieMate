//
//  GenresDecoder.swift
//  The Movie Database
//
//  Created by Beavean on 22.07.2022.
//

import Foundation

struct GenresDecoder {
    
    static let shared = GenresDecoder()
    
    private init() { }
    
    func decodeMovieGenreIDs(idNumbers:[Int]) -> String {
        var resultString = ""
        var idString = ""
        var decodingArray: [String] = []
        for id in idNumbers {
            switch id {
            case 28:
                idString = "Action"
            case 12:
                idString = "Adventure"
            case 16:
                idString = "Animation"
            case 35:
                idString = "Comedy"
            case 80:
                idString = "Crime"
            case 99:
                idString = "Documentary"
            case 18:
                idString = "Drama"
            case 10751:
                idString = "Family"
            case 14:
                idString = "Fantasy"
            case 36:
                idString = "History"
            case 27:
                idString = "Horror"
            case 10402:
                idString = "Music"
            case 9648:
                idString = "Mystery"
            case 10749:
                idString = "Romance"
            case 878:
                idString = "Science Fiction"
            case 10770:
                idString = "TV Movie"
            case 53:
                idString = "Thriller"
            case 10752:
                idString = "War"
            case 37:
                idString = "Western"
            default:
                idString = "Undefined"
            }
            decodingArray.append(idString)
        }
        resultString = decodingArray.joined(separator: ", ")
        return resultString
    }
}
