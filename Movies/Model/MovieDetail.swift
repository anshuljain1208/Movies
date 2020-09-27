//
//  MovieDetail.swift
//  Movies
//
//  Created by Anshul Jain on 26/9/20.
//  Copyright © 2020 Anshul Jain. All rights reserved.
//

import Foundation


struct MovieDetail: Codable {
  let title: String
  let year: String
  let type: String
  let imdbID: String
  let poster: String
  let imdbRating: String
  let imdbVotes: String
  let rated: String
  let released: String
  let runtime: String
  let genre: String
  let director: String
  let writer: String
  let actors: String
  let plot: String
  let language: String
  let country: String
  let awards: String
  let metascore: String
  let dvd: String
  let boxOffice: String
  let production: String
  let website: String
  let response: String
  let ratings: [Ratings]

  enum CodingKeys: String, CodingKey {
    case title = "Title"
    case year = "Year"
    case type = "Type"
    case imdbID
    case poster = "Poster"
    case imdbRating
    case imdbVotes
    case rated = "Rated"
    case released = "Released"
    case runtime = "Runtime"
    case genre = "Genre"
    case director = "Director"
    case writer = "Writer"
    case actors = "Actors"
    case plot = "Plot"
    case language = "Language"
    case country = "Country"
    case awards = "Awards"
    case metascore = "Metascore"
    case dvd = "DVD"
    case boxOffice = "BoxOffice"
    case production = "Production"
    case website = "Website"
    case response = "Response"
    case ratings = "Ratings"
  }

}


struct Ratings: Codable {
  let source: String
  let value: String

  enum CodingKeys: String, CodingKey {
    case source = "Source"
    case value = "Value"
  }

}

extension MovieDetail {
  var posterURL: URL? {
    return URL(string: poster, relativeTo: nil)
  }
}
