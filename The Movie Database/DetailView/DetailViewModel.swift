//
//  DetailViewModel.swift
//  The Movie Database
//
//  Created by Beavean on 04.08.2022.
//

import Foundation

protocol DetailViewModeling {
    var onError: (String) -> Void { get set }
    var onDataUpdated: () -> Void { get set }
    func updateData()
    
}

class DetailViewModel: DetailViewModeling {
    
    var onError: (String) -> Void = { _ in }
    var onDataUpdated = { }
    
    func updateData() {
        onDataUpdated()
    }
}
