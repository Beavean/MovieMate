//
//  SaveButtonManager.swift
//  The Movie Database
//
//  Created by Beavean on 30.07.2022.
//

import UIKit

struct SaveButtonManager {
    
    static let shared = SaveButtonManager()
    
    private init() { }
    
    func savePressed(sender: UIButton, mediaID: Int?, mediaType: String?) {
        guard let mediaID = mediaID, let mediaType = mediaType else { return }
        if RealmDataManager.shared.checkIfAlreadySaved(id: mediaID) {
            RealmDataManager.shared.deleteMedia(id: mediaID)
            sender.setImage(UIImage(systemName: "plus.square"), for: .normal)
        } else {
            let query = mediaType + "/" + String(mediaID) + Constants.Network.apiKey
            NetworkManager.shared.makeRequest(query: query, model: MediaSearch.Results?.self) { data in
                guard let data = data else { return }
                RealmDataManager.shared.saveMedia(from: data, mediaType: mediaType)
                sender.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            }
        }
    }
}
 
