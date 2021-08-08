//
//  Networking.swift
//  HumaTheMovieDBTestTask
//
//  Created by admin on 06.08.2021.
//

import Foundation

protocol ObtainMovies {
    func getPlayingNowMovies(with page: Int, completion: @escaping (Result<[Movie], Error>) -> Void)
    func getImageFromURL(with urlString: String, completion: @escaping (Result<Data, Error>) -> Void)
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
    
    func getImageFromURL(with urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: Constants.movieImagePath + urlString) else { completion(.failure(NetworkError.cantCreateURL))
            return
        }
        
        let task = URLSession.shared.downloadTask(with: url) { data, response, error in
            
            guard let data = data else { return }
            do {
                let imageData = try Data(contentsOf: data)
                completion(.success(imageData))
            } catch {
                completion(.failure(NetworkError.cantRetriveData))
            }
        }
        task.resume()

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

