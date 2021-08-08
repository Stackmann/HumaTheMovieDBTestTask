//
//  PlayingNowPresenter.swift
//  HumaTheMovieDBTestTask
//
//  Created by admin on 07.08.2021.
//
import UIKit

protocol PlayingNowViewModelProtocol: class {
    var view: PlayingNowViewProtocol? { get set }
    
    var playingNowMovies: [Movie] { get set }
    var curentPage: Int { get set }
    
    func loadPlayingNowMovies()
}

protocol PlayingNowViewProtocol: class {
    var viewModel: PlayingNowViewModelProtocol? { get set }
    func moviesIsObtained()
    func showAlert(with text: String)
}
