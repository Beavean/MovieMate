//
//  RealmObjectModel.swift
//  The Movie Database
//
//  Created by Beavean on 21.07.2022.
//

import Foundation
import RealmSwift

final class RealmObjectModel: Object {
   
    @Persisted var id: Int
    @Persisted var adult: Bool?
    @Persisted var backdropPath: String?
    @Persisted var genreIDs: String?
    @Persisted var originalLanguage: String?
    @Persisted var originalTitle: String?
    @Persisted var overview: String?
    @Persisted var popularity: Double?
    @Persisted var posterPath: String?
    @Persisted var releaseDate: String?
    @Persisted var title: String?
    @Persisted var video: Bool?
    @Persisted var voteAverage: Double?
    @Persisted var voteCount: Int?
    @Persisted var mediaType: String?
    @Persisted var dateSaved: Date?
    
    convenience init(id: Int) {
                self.init()
                self.id = id
            }
            
    override class func primaryKey() -> String? {
        "id"
    }
}
