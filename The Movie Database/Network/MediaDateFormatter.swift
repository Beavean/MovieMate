//
//  MediaDateFormatter.swift
//  The Movie Database
//
//  Created by Beavean on 23.07.2022.
//

import Foundation

struct MediaDateFormatter {
    
    static let shared = MediaDateFormatter()
    
    private init() { }
    
    func formatDate(from string: String?) -> String {
        guard let string = string else { return "No release date" }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en-US")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: string) else { return "No release date" }
        dateFormatter.dateFormat = "MMMM yyyy"
        let resultString = dateFormatter.string(from: date)
        return resultString
    }
}
