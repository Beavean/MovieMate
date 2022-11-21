//
//  NetworkManager.swift
//  The Movie Database
//
//  Created by Beavean on 02.08.2022.
//

import Foundation
import Alamofire

typealias BasicMediaCompletion = ([BasicMedia.Results]) -> ()

struct NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    private func makeRequest<T: Codable>(apiQuery: String, enteredQuery: String = "", model: T.Type, completion: @escaping (T) -> ()) {
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
            switch response.error {
            case .none:
                guard let response = response.data else { return }
                do {
                    let data = try JSONDecoder().decode(model, from: response)
                    completion(data)
                } catch {
                    print("JSON decode error:", error)
                }
            case .some(_):
                print("Server error: \(String(describing: response.error))")
            }
        }
    }
    
    func getTrendingMovies(completion: @escaping (BasicMediaCompletion)) {
        makeRequest(apiQuery: Constants.Network.trendingMovies, model: BasicMedia.self) { data in
            completion(data.results ?? [])
        }
    }
    
    func getTrendingSeries(completion: @escaping (BasicMediaCompletion)) {
        makeRequest(apiQuery: Constants.Network.trendingSeries, model: BasicMedia.self) { data in
            completion(data.results ?? [])
        }
    }
    
    func getSearchedMovies(enteredQuery: String, completion: @escaping (BasicMediaCompletion)) {
        makeRequest(apiQuery: Constants.Network.searchMovies, enteredQuery: enteredQuery, model: BasicMedia.self) { data in
            completion(data.results ?? [])
        }
    }
    
    func getSearchedSeries(enteredQuery: String, completion: @escaping (BasicMediaCompletion)) {
        makeRequest(apiQuery: Constants.Network.searchSeries, enteredQuery: enteredQuery, model: BasicMedia.self) { data in
            completion(data.results ?? [])
        }
    }
    
    func getMediaVideos(mediaID: Int, mediaType: String, completion: @escaping (([MediaVideos.Video])->())) {
        let query = Constants.Network.getMediaVideos(mediaID: mediaID, mediaType: mediaType)
        makeRequest(apiQuery: query, model: MediaVideos.self) { data in
            completion(data.results ?? [])
        }
    }
    
    func getMediaDetails(mediaID: Int, mediaType: String, completion: @escaping ((MediaDetails)->())) {
        let query = Constants.Network.getDetailsRequest(mediaID: mediaID, mediaType: mediaType)
        makeRequest(apiQuery: query, model: MediaDetails.self) { data in
            completion(data)
        }
    }
    
    func getNowPlayingMovies(completion: @escaping (BasicMediaCompletion)) {
        makeRequest(apiQuery: Constants.Network.nowPlayingMovies, model: BasicMedia.self) { data in
            completion(data.results ?? [])
        }
    }
    
    func getUpcomingMovies(completion: @escaping (BasicMediaCompletion)) {
        makeRequest(apiQuery: Constants.Network.upcomingMovies, model: BasicMedia.self) { data in
            completion(data.results ?? [])
        }
    }
    
    func getTopRatedMovies(completion: @escaping (BasicMediaCompletion)) {
        makeRequest(apiQuery: Constants.Network.topRatedMovies, model: BasicMedia.self) { data in
            completion(data.results ?? [])
        }
    }
    
    func getPopularSeries(completion: @escaping (BasicMediaCompletion)) {
        makeRequest(apiQuery: Constants.Network.popularSeries, model: BasicMedia.self) { data in
            completion(data.results ?? [])
        }
    }
    
    func getLatestSeries(completion: @escaping (BasicMediaCompletion)) {
        makeRequest(apiQuery: Constants.Network.onTheAirSeries, model: BasicMedia.self) { data in
            completion(data.results ?? [])
        }
    }
    
    func getTopRatedSeries(completion: @escaping (BasicMediaCompletion)) {
        makeRequest(apiQuery: Constants.Network.topRatedSeries, model: BasicMedia.self) { data in
            completion(data.results ?? [])
        }
    }
}