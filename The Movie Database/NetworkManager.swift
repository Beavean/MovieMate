//
//  NetworkManager.swift
//  The Movie Database
//
//  Created by Beavean on 30.07.2022.
//

import Foundation
import Alamofire

struct NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    func makeRequest<T: Codable>(query: String, model: T.Type, completion: @escaping (T) -> ()) {
        let baseUrl = Constants.Network.baseUrl
        guard let url = URL(string: baseUrl + query) else { return }
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
}

