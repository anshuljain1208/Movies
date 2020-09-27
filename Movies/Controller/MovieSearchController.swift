//
//  MovieSearchController.swift
//  Movies
//
//  Created by Anshul Jain on 26/9/20.
//  Copyright © 2020 Anshul Jain. All rights reserved.
//

import UIKit


protocol MovieSearchControllerDelegate: UIViewController {
   func reloadResult()
   func showError(title: String, message: String)
}

class MovieSearchController: NSObject {
  
  weak var delegate: MovieSearchControllerDelegate?
  let searchModel: MovieSearchViewModel
  let searchController = UISearchController(searchResultsController: nil)

  init(delegate: MovieSearchControllerDelegate, searchModel: MovieSearchViewModel) {
    self.delegate = delegate
    self.searchModel = searchModel
    super.init()
    setupSearchbar()
  }
  
  func setupSearchbar() {
    self.searchController.obscuresBackgroundDuringPresentation = false
    self.searchController.searchBar.placeholder = movieSearchControllerPlaceholder
    self.searchController.searchBar.delegate = self
  }

}

extension MovieSearchController: UISearchBarDelegate {

  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    //Show Cancel
    searchBar.setShowsCancelButton(true, animated: true)
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    //Filter function
    //self.filterFunction(searchText: searchText)
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    //Hide Cancel
    searchBar.setShowsCancelButton(false, animated: true)
    searchBar.resignFirstResponder()
    print("searchBarSearchButtonClicked query \(searchBar.text ?? "No Text")")
    guard let query = searchBar.text?.trimmingCharacters(in: .whitespaces), query.count > 2 else {
      return
    }
    delegate?.showActivityIndicaorView(withMessage: movieSearchControllerLoadingTitle )
    searchModel.searchMovies(query: query) { [weak self] (error) in
      guard let self = self else { return }
      self.delegate?.showActivityIndicaorView = false
      if let _error = error {
        self.delegate?.showError(title: movieSearchControllerErrorTitle, message: _error.localizedDescription)
      }
      self.delegate?.reloadResult()
    }
    delegate?.reloadResult()

  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    //Hide Cancel
    searchBar.setShowsCancelButton(false, animated: true)
    searchBar.text = String()
    searchBar.resignFirstResponder()
  }
}
