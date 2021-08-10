//
//  PlayingNowViewController.swift
//  HumaTheMovieDBTestTask
//
//  Created by admin on 08.08.2021.
//

import UIKit

final class PlayingNowViewController: UIViewController, PlayingNowViewProtocol {

    enum Constants {
        static let cellNibName = "PlayingNowTableViewCell"
        static let cellIdentifier = "cell"
    }
    
    var viewModel: PlayingNowViewModelProtocol?
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    // MARK: - Life cycle metods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel?.loadPlayingNowMovies()
    }
    
    // MARK: - own metods
    
    func moviesIsObtained() {
        tableView.reloadData()
        spinner.stopAnimating()
    }
    
    func showAlert(with text: String) {
        print(text)
    }
}

// MARK: - UITableViewDataSource

extension PlayingNowViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.playingNowMovies.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlayingNowTableViewCell
        
        cell.selectionStyle = .none
        if let viewModel = viewModel, viewModel.playingNowMovies.indices.contains(indexPath.row) {
            let movie = viewModel.playingNowMovies[indexPath.row]
            cell.configure(with: movie.name, newIndex: indexPath.row)
            viewModel.loadImageForCell(by: indexPath, to: cell)
        }
        //next page load observ
        let endIndexArray = [indexPath.row + 1, indexPath.row + 2, indexPath.row + 3]
        if let viewModel = viewModel, endIndexArray.contains(viewModel.playingNowMovies.count) {
            viewModel.loadPlayingNowMovies()
        }

        return cell
    }
}
