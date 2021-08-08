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
    
    init(view: PlayingNowViewProtocol, networkService: ObtainMovies) {
        self.view = view
        self.networkService = networkService
    }

    func loadPlayingNowMovies() {
        curentPage += 1
        TheMovieDB().getPlayingNowMovies(with: curentPage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.view?.showAlert(with: error.localizedDescription)
                }
            case .success(let receivedMovies):
                DispatchQueue.main.async {
                    self.playingNowMovies += receivedMovies
                    self.view?.moviesIsObtained()
                }
            }
        }
    }
}
