//
//  ModelStructures.swift
//  HumaTheMovieDBTestTask
//
//  Created by admin on 06.08.2021.
//

import Foundation

struct Movie: Hashable, Codable, Identifiable {
    var id = UUID()
    
    var idMovie: Int
    var name: String
    var posterPath: String
    
    enum CodingKeys: String, CodingKey {
        case idMovie = "id"
        case name = "title"
        case posterPath = "poster_path"
    }
}
