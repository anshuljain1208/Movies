//
//  MovieDetailViewModelTest.swift
//  MoviesTests
//
//  Created by Anshul Jain on 28/9/20.
//  Copyright © 2020 Anshul Jain. All rights reserved.
//

import XCTest
@testable import Movies

class MovieDetailViewModelTest: XCTestCase {

  var mockModel: MovieDetailViewModel {
    let movie = Movie(title: "Captain Marvel", year: "2019", imdbID: "tt4154664", type: "movie", poster: "https://m.media-amazon.com/images/M/MV5BMTE0YWFmOTMtYTU2ZS00ZTIxLWE3OTEtYTNiYzBkZjViZThiXkEyXkFqcGdeQXVyODMzMzQ4OTI@._V1_SX300.jpg")
    let model = MovieDetailViewModel(movie: movie)
    model.repo.session = URLSession(configuration: URLProtocolMock.configuration)
    URLProtocolMock.dataProviders = [RepositoryMockDataProvider.shared]
    return model
  }

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testDetailsResult_success() throws {
    let searchURL = "www.omdbapi.com"
    let mockData = try Helpers.mockData(fileName: "movie_detail", withExtension: "")
    RepositoryMockDataProvider.shared.dictionary[searchURL] = .success((data: mockData, response: .successHTTPStatusResponse()))
    let expecation = expectation(description: "testExample")
    var outcome: Error?
    let model = mockModel
    XCTAssert(model.details == nil)
    model.fetchDetails { (result) in
      outcome = result
      expecation.fulfill()
    }
    wait(for: [expecation], timeout: 20)
    XCTAssert(outcome == nil)
    XCTAssert(model.details != nil)
    XCTAssert(model.details!.title == "Captain Marvel")
    XCTAssert(model.details!.year == "2019")
    XCTAssert(model.details!.rated == "PG-13")
    XCTAssert(model.details!.runtime == "123 min")
    XCTAssert(model.details!.genre == "Action, Adventure, Sci-Fi")
    XCTAssert(model.details!.director == "Anna Boden, Ryan Fleck")
    XCTAssert(model.details!.writer == "Anna Boden (screenplay by), Ryan Fleck (screenplay by), Geneva Robertson-Dworet (screenplay by), Nicole Perlman (story by), Meg LeFauve (story by), Anna Boden (story by), Ryan Fleck (story by), Geneva Robertson-Dworet (story by)")
    XCTAssert(model.details!.actors == "Brie Larson, Samuel L. Jackson, Ben Mendelsohn, Jude Law")
    XCTAssert(model.details!.plot == "Carol Danvers becomes one of the universe's most powerful heroes when Earth is caught in the middle of a galactic war between two alien races.")
    XCTAssert(model.details!.posterURL == URL(string: "https://m.media-amazon.com/images/M/MV5BMTE0YWFmOTMtYTU2ZS00ZTIxLWE3OTEtYTNiYzBkZjViZThiXkEyXkFqcGdeQXVyODMzMzQ4OTI@._V1_SX300.jpg"))
    XCTAssert(model.details!.posterURL != nil)
  }

  func testDetailsResult_failed() throws {
    let searchURL = "www.omdbapi.com"
    let mockData = try Helpers.mockData(fileName: "search_result", withExtension: "")
    RepositoryMockDataProvider.shared.dictionary[searchURL] = .success((data: mockData, response: .badHTTPStatusResponse(400)))
    let expecation = expectation(description: "testExample")
    var outcome: Error?
    let model = mockModel
    XCTAssert(model.details == nil)
    model.fetchDetails { (result) in
      outcome = result
      expecation.fulfill()
    }
    wait(for: [expecation], timeout: 20)
    XCTAssert(outcome != nil)
    XCTAssert(model.details == nil)
  }

  func testDetailsResult_failed_invalid_json() throws {
    let searchURL = "www.omdbapi.com"
    let mockData = try Helpers.mockData(fileName: "movie_detail_bad_json", withExtension: "")
    RepositoryMockDataProvider.shared.dictionary[searchURL] = .success((data: mockData, response: .successHTTPStatusResponse()))
    let expecation = expectation(description: "testExample")
    var outcome: Error?
    let model = mockModel
    XCTAssert(model.details == nil)
    model.fetchDetails { (result) in
      outcome = result
      expecation.fulfill()
    }
    wait(for: [expecation], timeout: 20)
    XCTAssert(outcome != nil)
    XCTAssert(model.details == nil)
  }

  func testDetailsResult_failed_invalid_json_sucess() throws {
    let searchURL = "www.omdbapi.com"
    let mockData = try Helpers.mockData(fileName: "movie_detail_bad_json", withExtension: "")
    RepositoryMockDataProvider.shared.dictionary[searchURL] = .success((data: mockData, response: .successHTTPStatusResponse()))
    let expecation = expectation(description: "testExample")
    var outcome: Error?
    let model = mockModel
    XCTAssert(model.details == nil)
    model.fetchDetails { (result) in
      outcome = result
      expecation.fulfill()
    }
    wait(for: [expecation], timeout: 20)
    XCTAssert(outcome != nil)
    XCTAssert(model.details == nil)
    
    let mockData1 = try Helpers.mockData(fileName: "movie_detail", withExtension: "")
    RepositoryMockDataProvider.shared.dictionary[searchURL] = .success((data: mockData1, response: .successHTTPStatusResponse()))
    let expecation1 = expectation(description: "testExample")
    model.fetchDetails { (result) in
      outcome = result
      expecation1.fulfill()
    }
    wait(for: [expecation1], timeout: 20)
    XCTAssert(outcome == nil)
    XCTAssert(model.details != nil)
    XCTAssert(model.details!.title == "Captain Marvel")
    XCTAssert(model.details!.year == "2019")
    XCTAssert(model.details!.rated == "PG-13")
    XCTAssert(model.details!.runtime == "123 min")
    XCTAssert(model.details!.genre == "Action, Adventure, Sci-Fi")
    XCTAssert(model.details!.director == "Anna Boden, Ryan Fleck")
    XCTAssert(model.details!.writer == "Anna Boden (screenplay by), Ryan Fleck (screenplay by), Geneva Robertson-Dworet (screenplay by), Nicole Perlman (story by), Meg LeFauve (story by), Anna Boden (story by), Ryan Fleck (story by), Geneva Robertson-Dworet (story by)")
    XCTAssert(model.details!.actors == "Brie Larson, Samuel L. Jackson, Ben Mendelsohn, Jude Law")
    XCTAssert(model.details!.plot == "Carol Danvers becomes one of the universe's most powerful heroes when Earth is caught in the middle of a galactic war between two alien races.")
    XCTAssert(model.details!.posterURL == URL(string: "https://m.media-amazon.com/images/M/MV5BMTE0YWFmOTMtYTU2ZS00ZTIxLWE3OTEtYTNiYzBkZjViZThiXkEyXkFqcGdeQXVyODMzMzQ4OTI@._V1_SX300.jpg"))
    XCTAssert(model.details!.posterURL != nil)

  }

  func testDetailsResult_success_fail() throws {
    let searchURL = "www.omdbapi.com"
    let mockData = try Helpers.mockData(fileName: "movie_detail", withExtension: "")
    RepositoryMockDataProvider.shared.dictionary[searchURL] = .success((data: mockData, response: .successHTTPStatusResponse()))
    let expecation = expectation(description: "testExample")
    var outcome: Error?
    let model = mockModel
    XCTAssert(model.details == nil)
    model.fetchDetails { (result) in
      outcome = result
      expecation.fulfill()
    }
    wait(for: [expecation], timeout: 20)
    XCTAssert(outcome == nil)
    XCTAssert(model.details != nil)
    XCTAssert(model.details!.title == "Captain Marvel")
    XCTAssert(model.details!.year == "2019")
    XCTAssert(model.details!.rated == "PG-13")
    XCTAssert(model.details!.runtime == "123 min")
    XCTAssert(model.details!.genre == "Action, Adventure, Sci-Fi")
    XCTAssert(model.details!.director == "Anna Boden, Ryan Fleck")
    XCTAssert(model.details!.writer == "Anna Boden (screenplay by), Ryan Fleck (screenplay by), Geneva Robertson-Dworet (screenplay by), Nicole Perlman (story by), Meg LeFauve (story by), Anna Boden (story by), Ryan Fleck (story by), Geneva Robertson-Dworet (story by)")
    XCTAssert(model.details!.actors == "Brie Larson, Samuel L. Jackson, Ben Mendelsohn, Jude Law")
    XCTAssert(model.details!.plot == "Carol Danvers becomes one of the universe's most powerful heroes when Earth is caught in the middle of a galactic war between two alien races.")
    XCTAssert(model.details!.posterURL == URL(string: "https://m.media-amazon.com/images/M/MV5BMTE0YWFmOTMtYTU2ZS00ZTIxLWE3OTEtYTNiYzBkZjViZThiXkEyXkFqcGdeQXVyODMzMzQ4OTI@._V1_SX300.jpg"))
    XCTAssert(model.details!.posterURL != nil)
    
    let mockData1 = try Helpers.mockData(fileName: "movie_detail_bad_json", withExtension: "")
    RepositoryMockDataProvider.shared.dictionary[searchURL] = .success((data: mockData1, response: .successHTTPStatusResponse()))
    let expecation1 = expectation(description: "testExample")
    model.fetchDetails { (result) in
      outcome = result
      expecation1.fulfill()
    }
    wait(for: [expecation1], timeout: 20)
    XCTAssert(outcome != nil)
    XCTAssert(model.details == nil)
  }

}
