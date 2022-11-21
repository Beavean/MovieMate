//
//  RealmObjectManager.swift
//  The Movie Database
//
//  Created by Beavean on 21.07.2022.
//

import Foundation
import RealmSwift

struct RealmObjectManager {

    static let shared = RealmObjectManager()

    let realm = try? Realm()

    private init() { }

    func saveMedia(from model: MediaDetails, mediaType: String) {
        let movieRealm = RealmObjectModel()
        if (realm?.object(ofType: RealmObjectModel.self, forPrimaryKey: model.id)) != nil { return } else {
            movieRealm.mediaType = mediaType
            movieRealm.adult = model.adult ?? false
            movieRealm.backdropPath = model.backdropPath ?? ""
            movieRealm.genreIDs = model.convertGenresIntoString()
            movieRealm.id =  model.id ?? 0
            movieRealm.originalLanguage = model.originalLanguage ?? ""
            movieRealm.originalTitle = model.originalTitle ?? ""
            movieRealm.overview = model.overview ?? ""
            movieRealm.popularity = model.popularity ?? 0
            movieRealm.posterPath = model.posterPath ?? ""
            movieRealm.releaseDate = MediaDateFormatter.shared.formatDate(from: model.releaseDate ?? model.firstAirDate)
            movieRealm.title = model.title ?? model.name ?? ""
            movieRealm.video = model.video ?? false
            movieRealm.voteAverage = model.voteAverage ?? 0
            movieRealm.voteCount = model.voteCount ?? 0
            movieRealm.dateSaved = Date()
            try? realm?.write {
                realm?.add(movieRealm)
            }
        }
    }

    func getMedia() -> Results<RealmObjectModel>? {
        guard let movieResults = realm?.objects(RealmObjectModel.self) else { return nil }
        return movieResults
    }

    func deleteMedia(id: Int) {
        try? realm?.write {
            guard let realmObject = realm?.object(ofType: RealmObjectModel.self, forPrimaryKey: id) else { return }
            realm?.delete(realmObject)
        }
    }

    func checkIfAlreadySaved(id: Int?) -> Bool {
        if (realm?.object(ofType: RealmObjectModel.self, forPrimaryKey: id)) != nil {
            return true
        } else {
            return false
        }
    }
}
