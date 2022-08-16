//
//  NetworkManager.swift
//  The Movie Database
//
//  Created by Beavean on 02.08.2022.
//

import Foundation
import Alamofire

struct NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    func makeRequest<T: Codable>(apiQuery: String, enteredQuery: String = "", model: T.Type, completion: @escaping (T) -> ()) {
        let baseUrl = Constants.Network.baseUrl
        let apiKey = Constants.Network.apiKey
        var url: URL
        if enteredQuery.isEmpty {
            guard let urlFromString = URL(string: baseUrl + apiQuery + apiKey) else { return }
            url = urlFromString
        } else {
            guard let searchQuery = enteredQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
                  let urlFromString = URL(string: baseUrl + apiQuery + apiKey + "&query=" + searchQuery) else { return }
            url = urlFromString
        }
        AF.request(url).response { response in
            guard let response = response.data else { return }
            do {
                let data = try JSONDecoder().decode(model, from: response)
                completion(data)
            } catch {
                print("JSON decode error:", error)
            }
        }
    }
    
    func getTrendingMovies(completion: @escaping (([BasicMedia.Results])->())) {
        makeRequest(apiQuery: "trending/movie/week", model: BasicMedia.self) { data in
            completion(data.results ?? [])
        }
    }
    
    func getTrendingSeries(completion: @escaping (([BasicMedia.Results])->())) {
        makeRequest(apiQuery: "trending/tv/week", model: BasicMedia.self) { data in
            completion(data.results ?? [])
        }
    }
    
    func getSearchedMovies(enteredQuery: String, completion: @escaping (([BasicMedia.Results])->())) {
        makeRequest(apiQuery: "search/movie", enteredQuery: enteredQuery, model: BasicMedia.self) { data in
            completion(data.results ?? [])
        }
    }
    
    func getSearchedSeries(enteredQuery: String, completion: @escaping (([BasicMedia.Results])->())) {
        makeRequest(apiQuery: "search/tv", enteredQuery: enteredQuery, model: BasicMedia.self) { data in
            completion(data.results ?? [])
        }
    }
    
    func getMediaVideos(mediaID: Int, mediaType: String, completion: @escaping (([MediaVideos.Video])->())) {
        makeRequest(apiQuery: "\(mediaType)/\(mediaID)/videos", model: MediaVideos.self) { data in
            completion(data.results ?? [])
        }
    }
    
    func getMediaDetails(mediaID: Int, mediaType: String, completion: @escaping ((MediaDetails)->())) {
        makeRequest(apiQuery: "\(mediaType)/\(mediaID)", model: MediaDetails.self) { data in
            completion(data)
        }
    }
    
    func getNowPlayingMovies(completion: @escaping (([BasicMedia.Results])->())) {
        makeRequest(apiQuery: "movie/now_playing", model: BasicMedia.self) { data in
            completion(data.results ?? [])
        }
    }
    
    func getUpcomingMovies(completion: @escaping (([BasicMedia.Results])->())) {
        makeRequest(apiQuery: "movie/upcoming", model: BasicMedia.self) { data in
            completion(data.results ?? [])
        }
    }
    
    func getTopRatedMovies(completion: @escaping (([BasicMedia.Results])->())) {
        makeRequest(apiQuery: "movie/top_rated", model: BasicMedia.self) { data in
            completion(data.results ?? [])
        }
    }
    
    func getPopularSeries(completion: @escaping (([BasicMedia.Results])->())) {
        makeRequest(apiQuery: "tv/popular", model: BasicMedia.self) { data in
            completion(data.results ?? [])
        }
    }
    
    func getLatestSeries(completion: @escaping (([BasicMedia.Results])->())) {
        makeRequest(apiQuery: "tv/on_the_air", model: BasicMedia.self) { data in
            completion(data.results ?? [])
        }
    }
    
    func getTopRatedSeries(completion: @escaping (([BasicMedia.Results])->())) {
        makeRequest(apiQuery: "tv/top_rated", model: BasicMedia.self) { data in
            completion(data.results ?? [])
        }
    }
}
