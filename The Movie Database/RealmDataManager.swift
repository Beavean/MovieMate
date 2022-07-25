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
    
    
    @discardableResult func saveMedia(media: MoviesSearch.Results) -> Bool {
        let movieRealm = MovieRealm()
        
        if (realm?.object(ofType: MovieRealm.self, forPrimaryKey: media.title)) != nil {
            return false
        } else {
            
            movieRealm.adult = media.adult ?? false
            movieRealm.backdropPath = media.backdropPath ?? ""
            movieRealm.genreIDs = GenresDecoder.shared.decodeMovieGenreIDs(idNumbers: media.genreIDs!)
            movieRealm.id =  media.id ?? 0
            movieRealm.originalLanguage = media.originalLanguage ?? ""
            movieRealm.originalTitle = media.originalTitle ?? ""
            movieRealm.overview = media.overview ?? ""
            movieRealm.popularity = media.popularity ?? 0
            movieRealm.posterPath = media.posterPath ?? ""
            movieRealm.releaseDate = MediaDateFormatter.shared.formatDate(from: media.releaseDate ?? "")
            movieRealm.title = media.title ?? ""
            movieRealm.video = media.video ?? false
            movieRealm.voteAverage = media.voteAverage ?? 0
            movieRealm.voteCount = media.voteCount ?? 0
            try? realm?.write {
                realm?.add(movieRealm)
            }
            return true
        }
    }
    
    
    func getMedia() -> [MovieRealm] {
        var moviesRealm: [MovieRealm] = []
        
        guard let movieResults = realm?.objects(MovieRealm.self) else { return [] }
        
        for movie in movieResults {
            moviesRealm.append(movie)
        }
        return moviesRealm
    }
    
    func deleteMedia(media: MovieRealm) {
        try? realm?.write {
            realm?.delete((realm?.object(ofType: MovieRealm.self, forPrimaryKey: media.title))!)
        }
    }
    
}
