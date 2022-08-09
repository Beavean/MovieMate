//
//  SavedViewModel.swift
//  The Movie Database
//
//  Created by Beavean on 08.08.2022.
//

import Foundation

protocol SavedViewModeling {
    
    var arrayOfMedia: [RealmObjectModel] { get set }
    var onDataUpdated: () -> Void { get set }
    
    func loadSavedMedia()
}

class SavedViewModel: SavedViewModeling {
    
    var arrayOfMedia: [RealmObjectModel] = []
    var onDataUpdated = { }
    
    func loadSavedMedia() {
        arrayOfMedia = RealmObjectManager.shared.getMedia()
        onDataUpdated()
    }
}
