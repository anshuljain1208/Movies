//
//  RepositoryTests.swift
//  MoviesTests
//
//  Created by Anshul Jain on 27/9/20.
//  Copyright © 2020 Anshul Jain. All rights reserved.
//

import XCTest
@testable import Movies

class Helpers {
  static func mockData(fileName: String, withExtension ext: String) throws -> Data {
    let testBundle = Bundle(for: Helpers.self)
    guard let fileURL = testBundle.url(forResource: fileName, withExtension: ext)
      else { fatalError() }
    return try Data(contentsOf: fileURL)
  }
}

class RepositoryMockDataProvider: MockDataProvider {

  static let shared = RepositoryMockDataProvider()
  var dictionary = [String: MockResult]()
  func responseForRequest(request: URLRequest) -> MockResult? {
    let compo = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)!
    print("result is nil for request \(compo.host!)")
    guard let url = compo.host else {
      return nil
    }
    return dictionary[url]
  }
}

class RepositoryTests: XCTestCase {


  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  var mockRepo: Repository {
    let repo = Repository()
    repo.session = URLSession(configuration: URLProtocolMock.configuration)
    URLProtocolMock.dataProviders = [RepositoryMockDataProvider.shared]
    return repo
  }

  func testSearchResult_success() throws {
    let searchURL = "www.omdbapi.com"
    let mockData = try Helpers.mockData(fileName: "search_result", withExtension: "")
    RepositoryMockDataProvider.shared.dictionary[searchURL] = .success((data: mockData, response: .successHTTPStatusResponse()))
    let expecation = expectation(description: "testExample")
    var outcome: Result<MovieSearchList, HTTPError>?
    mockRepo.searchMovies(query: "test") { (result) in
      outcome = result
      expecation.fulfill()
    }
    wait(for: [expecation], timeout: 20)
    guard let result = outcome else {
      XCTAssert(false, "result is nil")
      return
    }
    switch result {
    case .success(let searchResult):
      XCTAssert(searchResult.totalResults == "111")
      XCTAssert(searchResult.response == "True")
      XCTAssert(searchResult.movies.count == 10)
      XCTAssert(searchResult.error == nil)
      XCTAssert(searchResult.movies[0].posterURL == URL(string: "https://m.media-amazon.com/images/M/MV5BMTE0YWFmOTMtYTU2ZS00ZTIxLWE3OTEtYTNiYzBkZjViZThiXkEyXkFqcGdeQXVyODMzMzQ4OTI@._V1_SX300.jpg"))
      XCTAssert(searchResult.movies[0].posterURL != nil)

    case .failure(let error):
      XCTAssert(false, "failed with invalide reason \(error)")
    }
  }

  func testSearchResult_success_no_result() throws {
    let searchURL = "www.omdbapi.com"
    let mockData = """
    {"Response":"False","Error":"Movie not found!"}
    """.data(using: .utf8)!
    RepositoryMockDataProvider.shared.dictionary[searchURL] = .success((data: mockData, response: .successHTTPStatusResponse()))
    let expecation = expectation(description: "testExample")
    var outcome: Result<MovieSearchList, HTTPError>?
    mockRepo.searchMovies(query: "test") { (result) in
      outcome = result
      expecation.fulfill()
    }
    wait(for: [expecation], timeout: 20)
    guard let result = outcome else {
      XCTAssert(false, "result is nil")
      return
    }
    switch result {
    case .success(let searchResult):
      XCTAssert(searchResult.totalResults == "0")
      XCTAssert(searchResult.response == "False")
      XCTAssert(searchResult.movies.count == 0)
      XCTAssert(searchResult.error == "Movie not found!")

    case .failure(let error):
      XCTAssert(false, "failed with invalide reason \(error)")
    }
  }

  

  func testSearchResult_failed() throws {
    let searchURL = "www.omdbapi.com"
    let mockData = try Helpers.mockData(fileName: "search_result", withExtension: "")
    RepositoryMockDataProvider.shared.dictionary[searchURL] = .success((data: mockData, response: .badHTTPStatusResponse(400)))
    let expecation = expectation(description: "testExample")
    var outcome: Result<MovieSearchList, HTTPError>?
    mockRepo.searchMovies(query: "test") { (result) in
      outcome = result
      expecation.fulfill()
    }
    wait(for: [expecation], timeout: 20)
    guard let result = outcome else {
      XCTAssert(false, "result is nil")
      return
    }
    switch result {
    case .success(let searchResult):
      XCTAssert(false, "should fail \(searchResult)")
    case .failure(let error):
      switch error {
      case .badHTTPStatus(_, let code):
        if code == 400 {
          XCTAssert(true)
        } else {
          XCTAssert(false, "should fail \(code)")
        }
      default:
        XCTAssert(false, "should fail \(error)")
      }
    }
  }

  func testDetailsResult_success() throws {
    let searchURL = "www.omdbapi.com"
    let mockData = try Helpers.mockData(fileName: "movie_detail", withExtension: "")
    RepositoryMockDataProvider.shared.dictionary[searchURL] = .success((data: mockData, response: .successHTTPStatusResponse()))
    let expecation = expectation(description: "testExample")
    var outcome: Result<MovieDetail, HTTPError>?
    mockRepo.fetechMoviedetails(imdbID: "test") { (result) in
      outcome = result
      expecation.fulfill()
    }
    wait(for: [expecation], timeout: 20)
    guard let result = outcome else {
      XCTAssert(false, "result is nil")
      return
    }
    switch result {
    case .success(let detail):
      XCTAssert(detail.title == "Captain Marvel")
      XCTAssert(detail.year == "2019")
      XCTAssert(detail.rated == "PG-13")
      XCTAssert(detail.runtime == "123 min")
      XCTAssert(detail.genre == "Action, Adventure, Sci-Fi")
      XCTAssert(detail.director == "Anna Boden, Ryan Fleck")
      XCTAssert(detail.writer == "Anna Boden (screenplay by), Ryan Fleck (screenplay by), Geneva Robertson-Dworet (screenplay by), Nicole Perlman (story by), Meg LeFauve (story by), Anna Boden (story by), Ryan Fleck (story by), Geneva Robertson-Dworet (story by)")
      XCTAssert(detail.actors == "Brie Larson, Samuel L. Jackson, Ben Mendelsohn, Jude Law")
      XCTAssert(detail.plot == "Carol Danvers becomes one of the universe's most powerful heroes when Earth is caught in the middle of a galactic war between two alien races.")
      XCTAssert(detail.posterURL == URL(string: "https://m.media-amazon.com/images/M/MV5BMTE0YWFmOTMtYTU2ZS00ZTIxLWE3OTEtYTNiYzBkZjViZThiXkEyXkFqcGdeQXVyODMzMzQ4OTI@._V1_SX300.jpg"))
      XCTAssert(detail.posterURL != nil)


    case .failure(let error):
      XCTAssert(false, "failed with invalide reason \(error)")
    }
  }

  func testDetailsResult_failed() throws {
    let searchURL = "www.omdbapi.com"
    let mockData = try Helpers.mockData(fileName: "search_result", withExtension: "")
    RepositoryMockDataProvider.shared.dictionary[searchURL] = .success((data: mockData, response: .badHTTPStatusResponse(400)))
    let expecation = expectation(description: "testExample")
    var outcome: Result<MovieDetail, HTTPError>?
    mockRepo.fetechMoviedetails(imdbID: "test") { (result) in
      outcome = result
      expecation.fulfill()
    }
    wait(for: [expecation], timeout: 20)
    guard let result = outcome else {
      XCTAssert(false, "result is nil")
      return
    }
    switch result {
    case .success(let searchResult):
      XCTAssert(false, "should fail \(searchResult)")
    case .failure(let error):
      switch error {
      case .badHTTPStatus(_, let code):
        if code == 400 {
          XCTAssert(true)
        } else {
          XCTAssert(false, "should fail \(code)")
        }
      default:
        XCTAssert(false, "should fail \(error)")
      }
    }
  }

  func testDetailsResult_failed_invalid_json() throws {
    let searchURL = "www.omdbapi.com"
    let mockData = try Helpers.mockData(fileName: "movie_detail_bad_json", withExtension: "")
    RepositoryMockDataProvider.shared.dictionary[searchURL] = .success((data: mockData, response: .successHTTPStatusResponse()))
    let expecation = expectation(description: "testExample")
    var outcome: Result<MovieDetail, HTTPError>?
    mockRepo.fetechMoviedetails(imdbID: "test") { (result) in
      outcome = result
      expecation.fulfill()
    }
    wait(for: [expecation], timeout: 20)
    guard let result = outcome else {
      XCTAssert(false, "result is nil")
      return
    }
    switch result {
    case .success(let searchResult):
      XCTAssert(false, "should fail \(searchResult)")
    case .failure(let error):
      switch error {
      case .jsonEncoding(_):
        XCTAssert(true)
      default:
        XCTAssert(false, "should fail \(error)")
      }
    }
  }
}
