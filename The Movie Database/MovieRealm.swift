//
//  MovieRealm.swift
//  The Movie Database
//
//  Created by Beavean on 21.07.2022.
//

import Foundation
import RealmSwift

class MovieRealm: Object {
   
    @objc dynamic var adult = false
    @objc dynamic var backdropPath = ""
//    @objc dynamic var genreIDs = [0]
    @objc dynamic var id = 0
    @objc dynamic var originalLanguage = ""
    @objc dynamic var originalTitle = ""
    @objc dynamic var overview = ""
    @objc dynamic var popularity = 0.0
    @objc dynamic var posterPath = ""
    @objc dynamic var releaseDate = ""
    @objc dynamic var title = ""
    @objc dynamic var video = false
    @objc dynamic var voteAverage = 0.0
    @objc dynamic var voteCount = 0
    
}
