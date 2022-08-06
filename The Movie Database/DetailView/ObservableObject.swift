//
//  ObservableObject.swift
//  The Movie Database
//
//  Created by Beavean on 06.08.2022.
//

import Foundation

final class ObservableObject<T> {
    
    var value: T?
    
    private var listener: ((T?) -> Void)?
    
    init(_ value: T?) {
        self.value = value
    }
    
    func bind(_ listener: @escaping(T?) -> Void) {
        listener(value)
        self.listener = listener
    }
}
