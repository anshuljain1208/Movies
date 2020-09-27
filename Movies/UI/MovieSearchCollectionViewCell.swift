//
//  MovieSearchCollectionViewCell.swift
//  Movies
//
//  Created by Anshul Jain on 26/9/20.
//  Copyright © 2020 Anshul Jain. All rights reserved.
//

import UIKit

class MovieSearchCollectionViewCell: UICollectionViewCell {

  let imageView = ImageView()
  let titleLabel = UILabel()

  func setup() {
    imageView.contentMode = .scaleAspectFill
    contentView.addSubview(imageView)
    imageView.alignEdgesToSuperView([.top, .left, .right, .bottom], inset: UIEdgeInsets(top: 0, left: 0, bottom: -54, right: 0))


    contentView.addSubview(titleLabel)
    titleLabel.alignEdgesToSuperView([.left, .right, .bottom], inset: UIEdgeInsets(top: 4, left: 4, bottom: 0, right: -4))
    titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    titleLabel.numberOfLines = 2
    titleLabel.textAlignment = .center
    titleLabel.font = UIFont.boldSystemFont(ofSize: 16)

  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }

  override func prepareForReuse() {
    imageView.setImage(imageURL: nil)
    titleLabel.text = ""
  }
}


extension MovieSearchCollectionViewCell {

  func setMovie(_ movie: Movie?) {
    guard let _movie = movie else {
      imageView.setImage(imageURL: nil)
      titleLabel.text = ""
      return;
    }
    imageView.setImage(imageURL: _movie.posterURL, placeHolder: UIImage(named: "no_movie"))
    titleLabel.text = _movie.title
  }
}
