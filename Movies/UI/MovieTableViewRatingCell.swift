//
//  MovieTableViewRatingCell.swift
//  Movies
//
//  Created by Anshul Jain on 27/9/20.
//  Copyright © 2020 Anshul Jain. All rights reserved.
//

import UIKit

class MovieTableViewRatingCell: UITableViewCell {
  
  let leftTitleLabel = UILabel()
  
  let centerTitleLabel = UILabel()

  let rightTitleLabel = MovieTableRatingView()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setup() {
    contentView.addSubview(leftTitleLabel)
    contentView.addSubview(centerTitleLabel)
    contentView.addSubview(rightTitleLabel)

    leftTitleLabel.alignEdgesToSuperView([.left], inset: UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12))
    leftTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

    centerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    centerTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    centerTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

    rightTitleLabel.alignEdgesToSuperView([.right], inset: UIEdgeInsets(top: 4, left: 12, bottom: 4, right: -12))
    rightTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

    let constraint = heightAnchor.constraint(equalToConstant: 20)
    constraint.priority = .init(rawValue: 999)
    constraint.isActive = true

    leftTitleLabel.font = UIFont.boldSystemFont(ofSize: 14)
    centerTitleLabel.font = UIFont.boldSystemFont(ofSize: 14)
  }
  
  
  func setRating(_ rating: String, message: String) {
    
  }
}

class MovieTableRatingView: UIView {
  
  let subtitleLabel = UILabel()
  private let ratingView = UIImageView(image: UIImage(named: "star_rating_1"))

  
  override init(frame: CGRect)  {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setup() {
    addSubview(subtitleLabel)
    addSubview(ratingView)

    ratingView.contentMode = .scaleAspectFit

    ratingView.alignEdgesToSuperView([.left])
    ratingView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    ratingView.widthAnchor.constraint(equalToConstant: 20).isActive = true

    subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    subtitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    ratingView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

    subtitleLabel.leadingAnchor.constraint(equalTo: ratingView.trailingAnchor, constant: 4).isActive = true
    heightAnchor.constraint(equalToConstant: 20).isActive = true
    widthAnchor.constraint(equalToConstant: 65).isActive = true

    subtitleLabel.numberOfLines = 1
    subtitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
  }
  
}

class MovieTableViewCriticsCell: UITableViewCell {
  
  let leftTitleLabel = UILabel()
  let leftSubtitleLabel = UILabel()

  let centerTitleLabel = UILabel()
  let centerSubtitleLabel = UILabel()

  let rightTitleLabel = UILabel()
  let rightSubtitleLabel = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setup() {
    contentView.addSubview(leftTitleLabel)
    contentView.addSubview(centerTitleLabel)
    contentView.addSubview(rightTitleLabel)
    contentView.addSubview(leftSubtitleLabel)
    contentView.addSubview(centerSubtitleLabel)
    contentView.addSubview(rightSubtitleLabel)

    leftTitleLabel.alignEdgesToSuperView([.left, .top], inset: UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12))
    leftSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    leftSubtitleLabel.centerXAnchor.constraint(equalTo: leftTitleLabel.centerXAnchor).isActive = true
    leftSubtitleLabel.topAnchor.constraint(equalTo: leftTitleLabel.bottomAnchor, constant: 8).isActive = true

    centerTitleLabel.alignEdgesToSuperView([.top], inset: UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12))
    centerTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    centerSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    centerSubtitleLabel.centerXAnchor.constraint(equalTo: centerTitleLabel.centerXAnchor).isActive = true
    centerSubtitleLabel.topAnchor.constraint(equalTo: centerTitleLabel.bottomAnchor, constant: 8).isActive = true

    rightTitleLabel.alignEdgesToSuperView([.right, .top], inset: UIEdgeInsets(top: 4, left: 12, bottom: 4, right: -12))
    rightSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    rightSubtitleLabel.centerXAnchor.constraint(equalTo: rightTitleLabel.centerXAnchor).isActive = true
    rightSubtitleLabel.topAnchor.constraint(equalTo: rightTitleLabel.bottomAnchor, constant: 8).isActive = true

    let constraint = heightAnchor.constraint(equalToConstant: 75)
    constraint.priority = .init(rawValue: 999)
    constraint.isActive = true

    leftTitleLabel.font = UIFont.boldSystemFont(ofSize: 14)
    centerTitleLabel.font = UIFont.boldSystemFont(ofSize: 14)
    rightTitleLabel.font = UIFont.boldSystemFont(ofSize: 14)
    
    leftSubtitleLabel.font = UIFont.systemFont(ofSize: 14)
    centerSubtitleLabel.font = UIFont.systemFont(ofSize: 14)
    rightSubtitleLabel.font = UIFont.systemFont(ofSize: 14)

  }
  
}
