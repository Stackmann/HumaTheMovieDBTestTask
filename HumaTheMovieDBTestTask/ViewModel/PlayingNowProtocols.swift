//
//  PlayingNowPresenter.swift
//  HumaTheMovieDBTestTask
//
//  Created by admin on 07.08.2021.
//
import UIKit

protocol PlayingNowViewModelProtocol: class {
    var view: PlayingNowViewProtocol? { get }
    
    var playingNowMovies: [Movie] { get }
    var curentPage: Int { get }
    
    func loadPlayingNowMovies()
    func loadImageForCell(by index: IndexPath, to cell: PlayingNowTableViewCell)
}

protocol PlayingNowViewProtocol: class {
    var viewModel: PlayingNowViewModelProtocol? { get set }
    func moviesIsObtained()
    func showAlert(with text: String)
}
