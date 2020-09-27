//
//  MovieSearchViewModel.swift
//  Movies
//
//  Created by Anshul Jain on 26/9/20.
//  Copyright © 2020 Anshul Jain. All rights reserved.
//

import Foundation

class MovieSearchViewModel {
  var searchResult: MovieSearchList?
  var searchQuery: String?
  let repo = Repository()
  private(set) var isLoading = false

  func searchMovies(query: String, completionHandler: @escaping (Error?) -> Void) {
    searchQuery = query
    searchResult = nil
    isLoading = true
    repo.searchMovies(query: query) { [weak self] (result) in
      guard let self = self else { return }
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        self.isLoading = false
        switch result {
        case .failure(let error):
          self.searchResult = nil
          completionHandler(error)
          print(error)
        case .success(let data):
          print(data)
          self.searchResult = data
          completionHandler(nil)
        }
      }
    }
  }

}


