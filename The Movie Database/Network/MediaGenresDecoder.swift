//
//  MediaGenresDecoder.swift
//  The Movie Database
//
//  Created by Beavean on 22.07.2022.
//

import Foundation

struct MediaGenresDecoder {
    static let shared = MediaGenresDecoder()

    private init() { }

    func decodeMovieGenreIDs(idNumbers: [Int]) -> String {
        if idNumbers.isEmpty {
            return "Genre is not specified"
        } else {
            var resultString = String()
            var idString = String()
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
                case 10765:
                    idString = "Sci-Fi & Fantasy"
                case 10766:
                    idString = "Soap"
                case 10767:
                    idString = "Talk"
                case 10768:
                    idString = "War & Politics"
                case 10764:
                    idString = "Reality"
                case 10763:
                    idString = "News"
                case 10762:
                    idString = "Kids"
                case 10759:
                    idString = "Action & Adventure"
                default:
                    idString = "Genre is not specified"
                }
                decodingArray.append(idString)
            }
            resultString = decodingArray.joined(separator: ", ")
            return resultString
        }
    }
}
