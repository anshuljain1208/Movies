//
//  MovieTableViewSynopsisCell.swift
//  Movies
//
//  Created by Anshul Jain on 27/9/20.
//  Copyright © 2020 Anshul Jain. All rights reserved.
//

import UIKit

class MovieTableViewSynopsisCell: UITableViewCell {
  
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
    
    titleLabel.alignEdgesToSuperView([.left, .top, .right], inset: UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12))
    subtitleLabel.alignEdgesToSuperView([.right, .left], inset: UIEdgeInsets(top: 4, left: 12, bottom: 4, right: -12))
    titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    subtitleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    subtitleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    subtitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 16).isActive = true
    subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
    contentView.bottomAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 4).isActive = true
    
    subtitleLabel.numberOfLines = 0
    subtitleLabel.font = UIFont.systemFont(ofSize: 14)
    titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
    subtitleLabel.textColor = #colorLiteral(red: 0.2941176471, green: 0.2941176471, blue: 0.2941176471, alpha: 1)
  }
  
}

