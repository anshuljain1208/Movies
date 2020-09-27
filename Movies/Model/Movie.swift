//
//  Movie.swift
//  Movies
//
//  Created by Anshul Jain on 26/9/20.
//  Copyright © 2020 Anshul Jain. All rights reserved.
//

import Foundation


struct Movie: Codable {
  let title: String
  let year: String
  let imdbID: String
  let type: String
  let poster: String

  enum CodingKeys: String, CodingKey {
    case title = "Title"
    case year = "Year"
    case type = "Type"
    case imdbID
    case poster = "Poster"
  }
}


struct MovieSearchList: Codable {
  let movies: [Movie]
  let totalResults: String
  let response: String
  let error: String?

  enum CodingKeys: String, CodingKey {
    case movies = "Search"
    case totalResults
    case response = "Response"
    case error = "Error"
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    response = try container.decode(String.self, forKey: .response)
    if response == "True" {
      movies = try container.decode([Movie].self, forKey: .movies)
      totalResults = try container.decode(String.self, forKey: .totalResults)
      error = nil
    } else {
      movies = []
      totalResults = "0"
      error = try container.decodeIfPresent(String.self, forKey: .error)
    }
  }
}


extension Movie {
  var posterURL: URL? {
    return URL(string: poster, relativeTo: nil)
  }
}
