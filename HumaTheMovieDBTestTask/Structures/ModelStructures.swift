//
//  ModelStructures.swift
//  HumaTheMovieDBTestTask
//
//  Created by admin on 06.08.2021.
//

import Foundation

struct Movie: Hashable, Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case idMovie = "id"
        case name = "title"
        case posterPath = "backdrop_path"
    }
    
    let id = UUID()
    let idMovie: Int
    let name: String
    let posterPath: String
}
