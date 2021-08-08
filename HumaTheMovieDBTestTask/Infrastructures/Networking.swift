//
//  Networking.swift
//  HumaTheMovieDBTestTask
//
//  Created by admin on 06.08.2021.
//

import Foundation

protocol ObtainMovies {
    func getPlayingNowMovies(with page: Int, completion: @escaping (Result<[Movie], Error>) -> Void)
}

class TheMovieDB: ObtainMovies {
    
    func getPlayingNowMovies(with page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard var urlComponents = URLComponents(string: Constants.playNowMoviesPath) else {
            completion(.failure(NetworkError.cantCreateURL))
            return
        }
        
        urlComponents.query = "api_key=\(Constants.apiKey)&page=\(page)"
        
        guard let url = urlComponents.url else {
            completion(.failure(NetworkError.cantCreateURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard (response as? HTTPURLResponse) != nil else {
                return
            }
            if let error = error {
                completion(.failure(error))
            } else {
                guard let data = data else {
                    completion(.failure(NetworkError.cantRetriveData))
                    return
                }
                do {
                    let responseResult = try JSONDecoder().decode(Response.self, from: data)
                    completion(.success(responseResult.movies))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    enum NetworkError: Error {
        case cantCreateURL
        case cantRetriveData
    }
}

struct Response: Codable {
    var page: Int
    var movies: [Movie]
    var totalResults: Int
    var totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case movies = "results"
    }
}

