//
//  PlayingNowViewController.swift
//  HumaTheMovieDBTestTask
//
//  Created by admin on 08.08.2021.
//

import UIKit

class PlayingNowViewController: UIViewController, PlayingNowViewProtocol {

    var viewModel: PlayingNowViewModelProtocol?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    //MARK: Life cycle metods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PlayingNowTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")

    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel?.loadPlayingNowMovies()
    }
    
    //MARK: own metods
    
    func moviesIsObtained() {
        tableView.reloadData()
        spinner.stopAnimating()
    }
    
    func showAlert(with text: String) {
        print(text)
    }
}

extension PlayingNowViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.playingNowMovies.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlayingNowTableViewCell
        cell.selectionStyle = .none
        if let viewModel = viewModel, viewModel.playingNowMovies.indices.contains(indexPath.row) {
            let movie = viewModel.playingNowMovies[indexPath.row]
            viewModel.loadImageForCell(by: indexPath, to: cell)
            cell.configure(with: movie.name)
        }

        return cell
    }
}
