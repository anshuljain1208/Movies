//
//  TableSectionFooterView.swift
//  Movies
//
//  Created by Anshul Jain on 27/9/20.
//  Copyright © 2020 Anshul Jain. All rights reserved.
//

import UIKit


class TableSectionFooterView: UIView {
  
  let borderView = UIView()

  
  override init(frame: CGRect)  {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setup() {
    addSubview(borderView)
    borderView.alignEdgesToSuperView([.left,.right])
    borderView.heightAnchor.constraint(equalToConstant: 2).isActive = true
    borderView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    borderView.backgroundColor = .systemGray6
  }
  
}

class MovieTableViewFooterCell: UITableViewCell {
  
  let footer = TableSectionFooterView()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setup() {
    contentView.addSubview(footer)
    footer.alignEdgesToSuperView([.top, .left, .right])
    footer.heightAnchor.constraint(equalToConstant: 10).isActive = true
    contentView.bottomAnchor.constraint(equalTo: footer.bottomAnchor, constant: 4).isActive = true
  }
  
}

