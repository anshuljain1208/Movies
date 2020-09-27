//
//  MovieSearchViewModelTests.swift
//  MoviesTests
//
//  Created by Anshul Jain on 28/9/20.
//  Copyright © 2020 Anshul Jain. All rights reserved.
//

import XCTest
@testable import Movies

class MovieSearchViewModelTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  var mockModel: MovieSearchViewModel {
    let model = MovieSearchViewModel()
    model.repo.session = URLSession(configuration: URLProtocolMock.configuration)
    URLProtocolMock.dataProviders = [RepositoryMockDataProvider.shared]
    return model
  }

  func testSearchResult_success() throws {
    let searchURL = "www.omdbapi.com"
    let mockData = try Helpers.mockData(fileName: "search_result", withExtension: "")
    RepositoryMockDataProvider.shared.dictionary[searchURL] = .success((data: mockData, response: .successHTTPStatusResponse()))
    let expecation = expectation(description: "testExample")
    var outcome: Error?
    let model = mockModel
    XCTAssert(model.searchResult == nil)
    model.searchMovies(query: "test") { (result) in
      outcome = result
      expecation.fulfill()
    }
    wait(for: [expecation], timeout: 20)
    XCTAssert(outcome == nil)
    XCTAssert(model.searchResult != nil)
    XCTAssert(model.searchResult!.totalResults == "111")
    XCTAssert(model.searchResult!.response == "True")
    XCTAssert(model.searchResult!.movies.count == 10)
    XCTAssert(model.searchResult!.error == nil)
    XCTAssert(model.searchResult!.movies[0].posterURL == URL(string: "https://m.media-amazon.com/images/M/MV5BMTE0YWFmOTMtYTU2ZS00ZTIxLWE3OTEtYTNiYzBkZjViZThiXkEyXkFqcGdeQXVyODMzMzQ4OTI@._V1_SX300.jpg"))
  }

  
  func testSearchResult_success_no_result() throws {
    let searchURL = "www.omdbapi.com"
    let mockData = """
    {"Response":"False","Error":"Movie not found!"}
    """.data(using: .utf8)!
    RepositoryMockDataProvider.shared.dictionary[searchURL] = .success((data: mockData, response: .successHTTPStatusResponse()))
    let expecation = expectation(description: "testExample")
    var outcome: Error?
    let model = mockModel
    XCTAssert(model.searchResult == nil)
    model.searchMovies(query: "test") { (result) in
      outcome = result
      expecation.fulfill()
    }
    wait(for: [expecation], timeout: 20)
    XCTAssert(outcome == nil)
    XCTAssert(model.searchResult != nil)
    XCTAssert(model.searchResult!.totalResults == "0")
    XCTAssert(model.searchResult!.response == "False")
    XCTAssert(model.searchResult!.movies.count == 0)
    XCTAssert(model.searchResult!.error == "Movie not found!")
  }

  func testSearchResult_failed() throws {
    let searchURL = "www.omdbapi.com"
    let mockData = try Helpers.mockData(fileName: "search_result", withExtension: "")
    RepositoryMockDataProvider.shared.dictionary[searchURL] = .success((data: mockData, response: .badHTTPStatusResponse(400)))
    let expecation = expectation(description: "testExample")
    var outcome: Error?
    let model = mockModel
    XCTAssert(model.searchResult == nil)
    model.searchMovies(query: "test") { (result) in
      outcome = result
      expecation.fulfill()
    }
    wait(for: [expecation], timeout: 20)
    XCTAssert(outcome != nil)
    XCTAssert(model.searchResult == nil)
  }

  func testSearchResult_success_fail() throws {
    let searchURL = "www.omdbapi.com"
    let mockData = try Helpers.mockData(fileName: "search_result", withExtension: "")
    RepositoryMockDataProvider.shared.dictionary[searchURL] = .success((data: mockData, response: .successHTTPStatusResponse()))
    let expecation = expectation(description: "testExample")
    var outcome: Error?
    let model = mockModel
    XCTAssert(model.searchResult == nil)
    XCTAssert(model.isLoading != true)
    model.searchMovies(query: "test") { (result) in
      outcome = result
      expecation.fulfill()
    }
    XCTAssert(model.isLoading == true)
    wait(for: [expecation], timeout: 20)
    XCTAssert(outcome == nil)
    XCTAssert(model.isLoading != true)
    XCTAssert(model.searchResult != nil)
    XCTAssert(model.searchResult!.totalResults == "111")
    XCTAssert(model.searchResult!.response == "True")
    XCTAssert(model.searchResult!.movies.count == 10)
    XCTAssert(model.searchResult!.error == nil)
    XCTAssert(model.searchResult!.movies[0].posterURL == URL(string: "https://m.media-amazon.com/images/M/MV5BMTE0YWFmOTMtYTU2ZS00ZTIxLWE3OTEtYTNiYzBkZjViZThiXkEyXkFqcGdeQXVyODMzMzQ4OTI@._V1_SX300.jpg"))
    RepositoryMockDataProvider.shared.dictionary[searchURL] = .success((data: mockData, response: .badHTTPStatusResponse(400)))
    let expecation1 = expectation(description: "testExample")
    model.searchMovies(query: "test") { (result) in
      outcome = result
      expecation1.fulfill()
    }
    XCTAssert(model.isLoading == true)
    wait(for: [expecation1], timeout: 20)
    XCTAssert(outcome != nil)
    XCTAssert(model.searchResult == nil)
    XCTAssert(model.isLoading != true)

  }

  func testSearchResult_fail_success() throws {
    let searchURL = "www.omdbapi.com"
    let mockData = try Helpers.mockData(fileName: "movie_detail", withExtension: "")
    RepositoryMockDataProvider.shared.dictionary[searchURL] = .success((data: mockData, response: .successHTTPStatusResponse()))
    let expecation = expectation(description: "testExample")
    var outcome: Error?
    let model = mockModel
    XCTAssert(model.searchResult == nil)
    model.searchMovies(query: "test") { (result) in
      outcome = result
      expecation.fulfill()
    }
    wait(for: [expecation], timeout: 20)
    XCTAssert(outcome != nil)
    XCTAssert(model.searchResult == nil)
    
    let mockData1 = """
    {"Response":"False","Error":"Movie not found!"}
    """.data(using: .utf8)!
    RepositoryMockDataProvider.shared.dictionary[searchURL] = .success((data: mockData1, response: .successHTTPStatusResponse()))
    let expecation1 = expectation(description: "testExample")
    XCTAssert(model.searchResult == nil)
    model.searchMovies(query: "test") { (result) in
      outcome = result
      expecation1.fulfill()
    }
    wait(for: [expecation1], timeout: 20)
    XCTAssert(outcome == nil)
    XCTAssert(model.searchResult != nil)
    XCTAssert(model.searchResult!.totalResults == "0")
    XCTAssert(model.searchResult!.response == "False")
    XCTAssert(model.searchResult!.movies.count == 0)
    XCTAssert(model.searchResult!.error == "Movie not found!")

  }

}
