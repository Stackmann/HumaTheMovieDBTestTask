//
//  ModuleBuilder.swift
//  HumaTheMovieDBTestTask
//
//  Created by admin on 08.08.2021.
//

import UIKit

protocol Factory {
    static func createMainView() -> UIViewController
}

class MainFactory: Factory {
    static func createMainView() -> UIViewController {
        let mainVC = PlayingNowViewController()
        let viewModel = PlayingNowViewModel(view: mainVC, networkService: TheMovieDB())
        mainVC.viewModel = viewModel
        let view = UINavigationController(rootViewController: mainVC)
        mainVC.title = "Playing now movies"
        return view
    }
}
