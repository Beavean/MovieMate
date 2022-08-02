//
//  NetworkManager2.swift
//  The Movie Database
//
//  Created by Beavean on 02.08.2022.
//

import Foundation

import Alamofire

struct AnotherNetworkManager {
    
    
    private func makeRequest<T: Codable>(apiQuery: String, enteredQuery: String = "", model: T.Type, completion: @escaping (T) -> ()) {
        let baseUrl = Constants.Network.baseUrl
        let apiKey = Constants.Network.apiKey
        guard let searchQuery = enteredQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url = URL(string: baseUrl + apiQuery + apiKey + "&query=" + searchQuery) else { return }
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
    
    func getTrendingMovies(completion: @escaping (([MediaSearch.Results])->())) {
        makeRequest(apiQuery: "trending/movie/week", model: MediaSearch.self) { data in
            completion(data.results ?? [])
        }
    }
    
    func getTrendingSeries(completion: @escaping (([MediaSearch.Results])->())) {
        makeRequest(apiQuery: "trending/tv/week", model: MediaSearch.self) { data in
            completion(data.results ?? [])
        }
    }
    
    func getSearchedMovies(enteredQuery: String, completion: @escaping (([MediaSearch.Results])->())) {
        makeRequest(apiQuery: "search/movie", enteredQuery: enteredQuery, model: MediaSearch.self) { data in
            completion(data.results ?? [])
        }
    }
    
    func getSearchedSeries(enteredQuery: String, completion: @escaping (([MediaSearch.Results])->())) {
        makeRequest(apiQuery: "search/tv", enteredQuery: enteredQuery, model: MediaSearch.self) { data in
            completion(data.results ?? [])
        }
    }
}

