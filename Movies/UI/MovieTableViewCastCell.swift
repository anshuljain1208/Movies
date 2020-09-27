//
//  MovieTableViewCastCell.swift
//  Movies
//
//  Created by Anshul Jain on 26/9/20.
//  Copyright © 2020 Anshul Jain. All rights reserved.
//

import UIKit


class MovieTableViewCastCell: UITableViewCell {
  
  let titleLabel = UILabel()
  let subtitleLabel = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setup() {
    contentView.addSubview(titleLabel)
    contentView.addSubview(subtitleLabel)
    titleLabel.alignEdgesToSuperView([.left, .top], inset: UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12))
    subtitleLabel.alignEdgesToSuperView([.right, .top], inset: UIEdgeInsets(top: 4, left: 12, bottom: 4, right: -12))
    subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 4).isActive = true
    subtitleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    subtitleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    subtitleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

    subtitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 16).isActive = true
    titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    contentView.bottomAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 4).isActive = true
    subtitleLabel.numberOfLines = 0
    titleLabel.numberOfLines = 0
    subtitleLabel.font = UIFont.systemFont(ofSize: 14)
    titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
    subtitleLabel.textColor = #colorLiteral(red: 0.2941176471, green: 0.2941176471, blue: 0.2941176471, alpha: 1)
  }
  
  override func prepareForReuse() {
    subtitleLabel.font = UIFont.systemFont(ofSize: 14)
    titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
    subtitleLabel.numberOfLines = 0
    titleLabel.numberOfLines = 0
  }
}

