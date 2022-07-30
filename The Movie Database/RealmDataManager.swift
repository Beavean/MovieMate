//
//  RealmDataManager.swift
//  The Movie Database
//
//  Created by Beavean on 21.07.2022.
//

import UIKit
import RealmSwift

struct RealmDataManager {
    
    static let shared = RealmDataManager()
    
    let realm = try? Realm()
    
    private init() { }
    
    @discardableResult func saveMedia(from model: MediaSearch.Results, mediaType: String) -> Bool {
        let movieRealm = MediaRealm()
        
        if (realm?.object(ofType: MediaRealm.self, forPrimaryKey: model.id)) != nil {
            return false
        } else {
            movieRealm.mediaType = mediaType
            movieRealm.adult = model.adult ?? false
            movieRealm.backdropPath = model.backdropPath ?? ""
            movieRealm.genreIDs = MediaGenresDecoder.shared.decodeMovieGenreIDs(idNumbers: model.genreIDs!)
            movieRealm.id =  model.id ?? 0
            movieRealm.originalLanguage = model.originalLanguage ?? ""
            movieRealm.originalTitle = model.originalTitle ?? ""
            movieRealm.overview = model.overview ?? ""
            movieRealm.popularity = model.popularity ?? 0
            movieRealm.posterPath = model.posterPath ?? ""
            movieRealm.releaseDate = MediaDateFormatter.shared.formatDate(from: model.releaseDate ?? "")
            movieRealm.title = (model.title ?? "").isEmpty == false ? model.title ?? "" : model.name ?? ""
            movieRealm.video = model.video ?? false
            movieRealm.voteAverage = model.voteAverage ?? 0
            movieRealm.voteCount = model.voteCount ?? 0
            try? realm?.write {
                realm?.add(movieRealm)
            }
            return true
        }
    }
    
    func getMedia() -> [MediaRealm] {
        var moviesRealm: [MediaRealm] = []
        
        guard let movieResults = realm?.objects(MediaRealm.self) else { return [] }
        
        for movie in movieResults {
            moviesRealm.append(movie)
        }
        return moviesRealm
    }
    
    func deleteMedia(id: Int) {
        try? realm?.write {
            guard let realmObject = realm?.object(ofType: MediaRealm.self, forPrimaryKey: id) else { return }
            realm?.delete(realmObject)
        }
    }
    
    func checkIfAlreadySaved(id: Int) -> Bool {
        if (realm?.object(ofType: MediaRealm.self, forPrimaryKey: id)) != nil {
            return true
        } else {
            return false
        }
    }
}
