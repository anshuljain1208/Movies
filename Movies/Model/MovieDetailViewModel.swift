//
//  MovieDetailViewModel.swift
//  Movies
//
//  Created by Anshul Jain on 26/9/20.
//  Copyright © 2020 Anshul Jain. All rights reserved.
//

import UIKit

enum MovieDetailCellProvider {
  case title, year, rating, synopsis, writer, director, actors, category, footer, critics


  static func type(forIndexPath indexPath: IndexPath) -> MovieDetailCellProvider {
    switch indexPath.section {
    case 0:
      switch indexPath.row {
      case 0:
        return .title
      case 1:
        return .year
      case 2:
        return .footer

      default:
        fatalError("MovieTableViewCastCell should not be nil")
      }
    case 1:
      switch indexPath.row {
      case 0:
        return .category
      case 1:
        return .rating
      case 2:
        return .synopsis
      case 3:
        return .critics

      case 4:
        return .footer
      default:
        fatalError("MovieTableViewCastCell should not be nil")
      }

    case 2:
      switch indexPath.row {
      case 0:
        return .writer
      case 1:
        return .director
      case 2:
        return .actors
      case 3:
        return .footer
      default:
        fatalError("MovieTableViewCastCell should not be nil")
      }
    default:
      fatalError("MovieTableViewCastCell should not be nil")
    }
  }

  static func registerCells(tableView: UITableView)  {
    tableView.register(MovieTableViewCastCell.self, forCellReuseIdentifier: "MovieTableViewCastCell")
    tableView.register(MovieTableViewSynopsisCell.self, forCellReuseIdentifier: "MovieTableViewSynopsisCell")
    tableView.register(MovieTableViewRatingCell.self, forCellReuseIdentifier: "MovieTableViewRatingCell")
    tableView.register(MovieTableViewFooterCell.self, forCellReuseIdentifier: "MovieTableViewFooterCell")
    tableView.register(MovieTableViewCriticsCell.self, forCellReuseIdentifier: "MovieTableViewCriticsCell")
    tableView.register(MovieTableViewTitleCell.self, forCellReuseIdentifier: "MovieTableViewTitleCell")
  }

  static func cellFor(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
    switch type(forIndexPath: indexPath) {
    case .title, .year:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewTitleCell", for: indexPath) as? MovieTableViewTitleCell else {
        fatalError("MovieTableViewTitleCell should not be nil")
      }
      return cell
      case .writer, .actors, .director, .category:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCastCell", for: indexPath) as? MovieTableViewCastCell else {
          fatalError("MovieTableViewCastCell should not be nil")
        }
        return cell

    case .rating:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewRatingCell", for: indexPath) as? MovieTableViewRatingCell else {
        fatalError("MovieTableViewRatingCell should not be nil")
      }
      return cell
    case .synopsis:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewSynopsisCell", for: indexPath) as? MovieTableViewSynopsisCell else {
        fatalError("MovieTableViewCastCell should not be nil")
      }
      return cell
    case .footer:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewFooterCell", for: indexPath) as? MovieTableViewFooterCell else {
        fatalError("MovieTableViewFooterCell should not be nil")
      }
      return cell
    case .critics:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCriticsCell", for: indexPath) as? MovieTableViewCriticsCell else {
        fatalError("MovieTableViewFooterCell should not be nil")
      }
      return cell

    }
  }
}

class MovieDetailViewModel {

  let repo = Repository()
  let movie: Movie
  private(set) var details: MovieDetail?

  init(movie: Movie) {
    self.movie = movie
  }

  func fetchDetails(completionHandler: @escaping (Error?) -> Void) {
    repo.fetechMoviedetails(imdbID: movie.imdbID) { (result) in
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        switch result {
        case .failure(let error):
          self.details = nil
          completionHandler(error)
          print(error)
        case .success(let movieDetails):
          self.details = movieDetails
          completionHandler(nil)
        }
      }
    }
  }
}


extension MovieDetailViewModel {
  func noOfSections() -> Int {
    return details == nil ? 0 : 3
  }

  func numberOfRows(inSection section: Int) -> Int {
    switch section {
    case 0:
      return 3
    case 1:
      return 5
    case 2:
      return 4
    default:
      return 0
    }
  }

  func configureSubtitleCell(_ cell: UITableViewCell, title: String?, subtitle: String? = nil, titleFont: UIFont? = nil) {
    let cell = cell as! MovieTableViewCastCell
    cell.titleLabel.text = title
    cell.subtitleLabel.text = subtitle
    if let _titleFont = titleFont {
      cell.titleLabel.font = _titleFont
    }
  }

  func configure(cell: UITableViewCell, forType type: MovieDetailCellProvider) {
    print("configure forType \(type)")
    switch type {
    case .title:
      configureSubtitleCell(cell, title: details?.title, titleFont: UIFont.boldSystemFont(ofSize: 24))
    case .year:
      configureSubtitleCell(cell, title: details?.year)
    case .rating:
      let cell = cell as! MovieTableViewRatingCell
      cell.leftTitleLabel.text = details?.rated
      cell.centerTitleLabel.text = details?.runtime
      cell.rightTitleLabel.subtitleLabel.text = details?.imdbRating
    case .synopsis:
      let cell = cell as! MovieTableViewSynopsisCell
      cell.titleLabel.text = movieDetailViewControllerCellTitleSynopsis
      cell.subtitleLabel.text = details?.plot
    case .writer:
      configureSubtitleCell(cell, title: movieDetailViewControllerCellTitleWriters, subtitle: details?.writer)
    case .director:
      configureSubtitleCell(cell, title: movieDetailViewControllerCellTitleDirectors, subtitle: details?.director)
    case .actors:
      configureSubtitleCell(cell, title: movieDetailViewControllerCellTitleActors, subtitle: details?.actors)
    case .category:
      configureSubtitleCell(cell, title: details?.genre)
    case .critics:
      let cell = cell as! MovieTableViewCriticsCell
      cell.leftTitleLabel.text = movieDetailViewControllerCellTitleRating
      cell.centerTitleLabel.text = movieDetailViewControllerCellTitleVotes
      cell.rightTitleLabel.text = movieDetailViewControllerCellTitlePopularity
      cell.leftSubtitleLabel.text = details?.imdbRating
      cell.centerSubtitleLabel.text = details?.imdbVotes
      cell.rightSubtitleLabel.text = details?.metascore
    default:
      break

    }
  }

}
