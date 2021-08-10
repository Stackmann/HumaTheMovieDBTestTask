//
//  NowPlayingViewModel.swift
//  HumaTheMovieDBTestTask
//
//  Created by admin on 06.08.2021.
//

import UIKit

final class PlayingNowViewModel: PlayingNowViewModelProtocol {
    weak var view: PlayingNowViewProtocol?
    private let networkService: MovieObtainable
    var playingNowMovies = [Movie]()
    var curentPage = 0
    private var attemptsLoadImages = [Int: Int]()
    private let maxCountAttempt = 5
    private var cacheLoadImages = [Int: UIImage]()
    var totalPages = 0

    init(view: PlayingNowViewProtocol, networkService: MovieObtainable) {
        self.view = view
        self.networkService = networkService
    }

    func loadPlayingNowMovies() {
        curentPage += 1
        if totalPages > 0 && totalPages < curentPage { return }
        networkService.getPlayingNowMovies(with: curentPage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.view?.showAlert(with: error.localizedDescription)
                }
            case .success(let response):
                DispatchQueue.main.async {
                    self.playingNowMovies += response.movies
                    self.totalPages = response.totalPages
                    self.view?.moviesIsObtained()
                }
            }
        }
    }
    
    func loadImageForCell(by index: IndexPath, completion: @escaping (Int, UIImage) -> ()) {
        guard playingNowMovies.indices.contains(index.row) else { return }
        let movie = playingNowMovies[index.row]
        
        if let image = cacheLoadImages[index.row] {
            completion(index.row, image)
            return
        }
        
        if increaseCountAttemptGettingImage(of: index.row, path: movie.posterPath) {return}
        
        networkService.getImageFromURL(with: movie.posterPath) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error.localizedDescription) //???
                self.loadImageForCell(by: index, completion: completion)
            case .success(let dataImage):
                DispatchQueue.main.async {
                    if let image = UIImage(data: dataImage) {
                        completion(index.row, image)
                        self.cacheLoadImages[index.row] = image
                    } else { self.loadImageForCell(by: index, completion: completion) }
                }
            }
        }
    }
    
    private func increaseCountAttemptGettingImage(of index: Int, path: String) -> Bool {
        guard let countAttempt = attemptsLoadImages[index] else {
            attemptsLoadImages[index] = 1
            return false }
        guard countAttempt < maxCountAttempt else {
            attemptsLoadImages[index] = countAttempt + 1
            return false }
        print("Achive max attempt count for: \(Constants.movieImagePath + path)")
        return true
    }
}
