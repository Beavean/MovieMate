//
//  SavedViewModel.swift
//  The Movie Database
//
//  Created by Beavean on 08.08.2022.
//

import Foundation
import RealmSwift

protocol SavedViewModeling {

    var arrayOfMedia: Results<RealmObjectModel>? { get set }
    var onDataUpdated: () -> Void { get set }

    func loadSavedMedia(searchText: String?)
}

final class SavedViewModel: SavedViewModeling {

    // MARK: - Properties

    var arrayOfMedia: Results<RealmObjectModel>?
    var onDataUpdated = { }

    // MARK: - Loading data

    func loadSavedMedia(searchText: String?) {
        if let searchText = searchText {
            if searchText.isEmpty {
                arrayOfMedia = RealmObjectManager.shared.getMedia()
            } else {
                arrayOfMedia = RealmObjectManager.shared.getMedia().filter("title CONTAINS[cd] %@", searchText).sorted(byKeyPath: "dateSaved", ascending: true)
            }
        }
        onDataUpdated()
    }
}
