//
//  ViewModelTests.swift
//  HumaTheMovieDBTestTaskTests
//
//  Created by admin on 09.08.2021.
//

import XCTest
import UIKit
@testable import HumaTheMovieDBTestTask

class MockNetworking: ObtainMovies {
    func getPlayingNowMovies(with page: Int, completion: @escaping (Result<Response, Error>) -> Void) {
        
        var movies = [Movie]()
        switch page {
        case 1:
            let movie = Movie(idMovie: 1, name: "Spader man", posterPath: "/SpiderMan.jpg")
            movies.append(movie)
        case 2:
            let movie = Movie(idMovie: 2, name: "Iron man", posterPath: "/IronMan.jpg")
            movies.append(movie)
        case 3:
            let movie = Movie(idMovie: 3, name: "Avengers", posterPath: "/Avengers.jpg")
            movies.append(movie)
        default:
            let movie = Movie(idMovie: 4, name: "Common film", posterPath: "/common.jpg")
            movies.append(movie)
        }
        
        let response = Response(page: page, movies: movies, totalResults: 1000, totalPages: 50)
        DispatchQueue.global().sync {
            completion(.success(response))
        }
        
    }
    
    func getImageFromURL(with urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
    }
}

class MockView: PlayingNowViewProtocol {
    var viewModel: PlayingNowViewModelProtocol?
    var moviesIsObtainedFlag = false
    
    func moviesIsObtained() {
        moviesIsObtainedFlag = true
    }
    
    func showAlert(with text: String) {
        print(text)
    }
}

class ViewModelTests: XCTestCase {
    var networkService: MockNetworking!
    var view: MockView!
    var viewModel: PlayingNowViewModel!

    override func setUpWithError() throws {
        networkService = MockNetworking()
        view = MockView()
        viewModel = PlayingNowViewModel(view: view, networkService: networkService)
    }

    override func tearDownWithError() throws {
        networkService = nil
        view = nil
        viewModel = nil
    }

    func testObtainFilms() throws {
        viewModel.loadPlayingNowMovies() //first page
        wait(for: 1)
        XCTAssertTrue(viewModel.playingNowMovies.count > 0)
        XCTAssertTrue(view.moviesIsObtainedFlag)

        viewModel.loadPlayingNowMovies() //second page
        wait(for: 1)
        XCTAssertTrue(viewModel.playingNowMovies.count > 1)

        viewModel.loadPlayingNowMovies() //third page
        wait(for: 1)
        XCTAssertTrue(viewModel.playingNowMovies.count > 2)
    }

}

extension XCTestCase {

  func wait(for duration: TimeInterval) {
    let waitExpectation = expectation(description: "Waiting")

    let when = DispatchTime.now() + duration
    DispatchQueue.main.asyncAfter(deadline: when) {
      waitExpectation.fulfill()
    }

    // We use a buffer here to avoid flakiness with Timer on CI
    waitForExpectations(timeout: duration + 0.5)
  }
}
