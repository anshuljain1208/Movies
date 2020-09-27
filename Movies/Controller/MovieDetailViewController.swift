//
//  MovieDetailController.swift
//  Movies
//
//  Created by Anshul Jain on 26/9/20.
//  Copyright © 2020 Anshul Jain. All rights reserved.
//

import UIKit

class MovieDetailViewController: UITableViewController {

  let viewModel: MovieDetailViewModel
  let imageView = ImageView(frame: CGRect.zero)

  init(movie: Movie) {
    viewModel = MovieDetailViewModel(movie: movie)
    super.init(style: .plain)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) not been implemented")
  }

  override func loadView() {
    super.loadView()
    tableView = ParallaxTableView(frame: CGRect.zero, style: .plain)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.delegate = self
    tableView.dataSource = self
    tableView.allowsSelection = false
    tableView.separatorStyle = .none
    MovieDetailCellProvider.registerCells(tableView: tableView)
    tableView.estimatedRowHeight = UITableView.automaticDimension
    tableView.rowHeight = UITableView.automaticDimension
  }

  func fetechDetails() {
    showActivityIndicaorView(withMessage: movieDetailViewControllerLoadingTitle)
    viewModel.fetchDetails { [weak self] error in
      guard let self = self else { return }
      self.showActivityIndicaorView = false
      if let _error = error {
        self.showError(title: movieDetailViewControllerErrorTitle, message: _error.localizedDescription)
      }
      self.imageView.setImage(imageURL: self.viewModel.details?.posterURL, placeHolder: UIImage(named: "no_movie"))
      self.tableView.reloadData()
      self.tableView.beginUpdates()
      self.tableView.endUpdates()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = movieDetailViewControllerTitle
    setupParallaxHeader()
    fetechDetails()
  }

  private func setupParallaxHeader() {
    imageView.image = UIImage(named: "no_movie")
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = false
    let tableView = self.tableView as! ParallaxTableView
    let height = UIScreen.main.bounds.size.width * 3 / 2
    tableView.setParallaxHeaderView(view: imageView, mode: .topFill, height: height)
  }

  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel.noOfSections()
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRows(inSection: section)
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = MovieDetailCellProvider.cellFor(indexPath: indexPath, tableView: tableView)
    viewModel.configure(cell: cell, forType: .type(forIndexPath: indexPath))
    return cell
  }

}
