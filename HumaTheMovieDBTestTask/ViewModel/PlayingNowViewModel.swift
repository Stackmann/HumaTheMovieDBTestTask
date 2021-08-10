//
//  NowPlayingViewModel.swift
//  HumaTheMovieDBTestTask
//
//  Created by admin on 06.08.2021.
//

import UIKit

class PlayingNowViewModel: PlayingNowViewModelProtocol {
    weak var view: PlayingNowViewProtocol?
    let networkService: ObtainMovies
    var playingNowMovies = [Movie]()
    internal var curentPage = 0
    var attemptsLoadImages = [Int: Int]()
    let maxCountAttempt = 5
    var cacheLoadImages = [Int: UIImage]()
    var totalPages = 0

    init(view: PlayingNowViewProtocol, networkService: ObtainMovies) {
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
    
    func loadImageForCell(by index: IndexPath, to cell: PlayingNowTableViewCell) {
        guard playingNowMovies.indices.contains(index.row) else { return }
            let movie = playingNowMovies[index.row]
            
            if let image = cacheLoadImages[index.row] {
                cell.setLogo(with: image)
                return
            }

            if let countAttempt = attemptsLoadImages[index.row] {
                if countAttempt >= maxCountAttempt {
                    print("Achive max attempt count for: \(Constants.movieImagePath + movie.posterPath)")
                    return
                }
                attemptsLoadImages[index.row] = countAttempt + 1
            } else {
                attemptsLoadImages[index.row] = 1
            }
            
            networkService.getImageFromURL(with: movie.posterPath) { [weak cell, weak self] result in
                guard let cell = cell else { return }
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    print(error.localizedDescription) //???
                    self.loadImageForCell(by: index, to: cell)
                case .success(let dataImage):
                    DispatchQueue.main.async {
                        if let image = UIImage(data: dataImage) {
                            if cell.index == index.row {
                                cell.setLogo(with: image)
                                self.cacheLoadImages[index.row] = image }
                        } else { self.loadImageForCell(by: index, to: cell) }
                    }
                }

            }
    }
}
