//
//  MoviesSearchController.swift
//  Movies
//
//  Created by Anshul Jain on 26/9/20.
//  Copyright © 2020 Anshul Jain. All rights reserved.
//

import UIKit

let reuseIdentifier = "movieSearchCell"

class MoviesSearchController: UICollectionViewController, MovieSearchControllerDelegate {
  private let sectionInsets = UIEdgeInsets(top: 20.0,
    left: 12,
    bottom: 20.0,
    right: 12)
  
  let searchModel = MovieSearchViewModel()
  let backgroundLabel = UILabel()
  let backgroundView = UIView()

  lazy var searchController: MovieSearchController = {
    return MovieSearchController(delegate:self , searchModel: searchModel)
  }()
  
  var flowLayout: UICollectionViewFlowLayout {
    return collectionView.collectionViewLayout as! UICollectionViewFlowLayout
  }

  @objc override var activityIndicatorSuperView: UIView {
    return backgroundView
  }
  
  @objc override var activityIndicatorBackgroundColor: UIColor {
    return UIColor.clear
  }

  @objc override var activityIndicatorColor: UIColor {
    return UIColor.systemGray
  }

  func setBackgroundMessageView() {
    backgroundView.addSubview(backgroundLabel)
    backgroundLabel.alignEdgesToGuide(.all, inset: UIEdgeInsets(top: 12, left: 12, bottom: -12, right: -12))
    backgroundLabel.text = initialSearchMessage
    backgroundLabel.textAlignment = .center
    backgroundLabel.textColor = .systemGray
    backgroundLabel.numberOfLines = 0
    collectionView.backgroundView = backgroundView
  }
  
  override func viewDidLoad() {
    title = moviesSearchControllerTitle
    setBackgroundMessageView()
    self.definesPresentationContext = true
    self.navigationItem.searchController = searchController.searchController
  }

  
  func reloadResult() {
    if searchModel.isLoading {
      backgroundLabel.text = ""
    } else {
      let count = searchModel.searchResult?.movies.count ?? 0
      if count == 0 {
        backgroundLabel.text = noSearchResultMessage
      } else {
        backgroundLabel.text = ""
      }
    }
    collectionView.reloadData()
  }

}

// MARK: UICollectionViewDataSource
extension MoviesSearchController {
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return searchModel.searchResult?.movies.count ?? 0
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MovieSearchCollectionViewCell else {
      fatalError("should always return MovieSearchCollectionViewCell")
    }
    cell.setMovie(searchModel.searchResult?.movies[indexPath.row])
    return cell
  }
}

// MARK: UICollectionViewDelegate
extension MoviesSearchController {

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let movie = searchModel.searchResult?.movies[indexPath.row] {
      navigationController?.pushViewController(MovieDetailViewController(movie: movie), animated: true)
    }
  }
}

// MARK: UICollectionViewDelegateFlowLayout
extension MoviesSearchController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath) -> CGSize {
    let itemsPerRow: CGFloat = 2
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    return CGSize(width: widthPerItem, height: widthPerItem * 3 / 2 + 50)
  }

  func collectionView(_ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }

  func collectionView(_ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
  }
}
