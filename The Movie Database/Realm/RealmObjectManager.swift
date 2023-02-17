//
//  RealmObjectManager.swift
//  The Movie Database
//
//  Created by Beavean on 21.07.2022.
//

import Foundation
import RealmSwift

final class RealmObjectManager {
    static let shared = RealmObjectManager()

    private let realm: Realm

    private init() {
        do {
            self.realm = try Realm()
        } catch {
            fatalError("Failed to create Realm instance: \(error)")
        }
    }

    func saveMedia(from model: MediaDetails, mediaType: String) {
        guard !checkIfAlreadySaved(id: model.id) else { return }

        let movieRealm = RealmObjectModel()
        movieRealm.mediaType = mediaType
        movieRealm.adult = model.adult ?? false
        movieRealm.backdropPath = model.backdropPath ?? ""
        movieRealm.genreIDs = model.convertGenresIntoString()
        movieRealm.id = model.id ?? 0
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

        do {
            try realm.write {
                realm.add(movieRealm)
            }
        } catch {
            print("Failed to save media: \(error)")
        }
    }

    func getMedia() -> Results<RealmObjectModel> {
        return realm.objects(RealmObjectModel.self)
    }

    func deleteMedia(id: Int) {
        guard let realmObject = realm.object(ofType: RealmObjectModel.self, forPrimaryKey: id) else { return }

        do {
            try realm.write {
                realm.delete(realmObject)
            }
        } catch {
            print("Failed to delete media: \(error)")
        }
    }

    func checkIfAlreadySaved(id: Int?) -> Bool {
        guard let id = id else { return false }
        return realm.object(ofType: RealmObjectModel.self, forPrimaryKey: id) != nil
    }
}
