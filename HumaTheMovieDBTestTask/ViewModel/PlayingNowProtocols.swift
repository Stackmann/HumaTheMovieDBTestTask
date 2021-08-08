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
    func loadImageForCell(by index: IndexPath, to cell: PlayingNowTableViewCell)
}

protocol PlayingNowViewProtocol: class {
    var viewModel: PlayingNowViewModelProtocol? { get set }
    func moviesIsObtained()
    func showAlert(with text: String)
}
