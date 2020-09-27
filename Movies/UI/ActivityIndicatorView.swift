//
//  ActivityIndicatorView.swift
//  Movies
//
//  Created by Anshul Jain on 26/9/20.
//  Copyright © 2020 Anshul Jain. All rights reserved.
//

import UIKit

protocol ActivityView: UIView {
  func stopAnimating()
  func startAnimating()
  var color: UIColor! { get set }
  var hidesWhenStopped: Bool { get set }
  var isAnimating: Bool { get }
  var message: String? { get set }
  var activityIndicatorColor: UIColor { get set }
}

extension UIActivityIndicatorView: ActivityView {

  var activityIndicatorColor: UIColor {
    set {
      color = newValue
    }
    get {
      return color
    }
  }

  var message: String? {
    set {

    }
    get {
      return nil
    }
  }

}

class ActivityViewWithLabel: UIView, ActivityView {
  func stopAnimating() {
    indicatorView.stopAnimating()
    isAnimating = false
  }

  var activityIndicatorColor: UIColor {
    set {
      indicatorView.color = newValue
      loadingLabel.textColor = newValue
    }
    get {
      return indicatorView.color
    }
  }


  func startAnimating() {
    indicatorView.startAnimating()
    isAnimating = true
  }

  var color: UIColor! = .clear {
    didSet {
      indicatorView.color = color
    }
  }

  var hidesWhenStopped: Bool = true {
    didSet {
      indicatorView.hidesWhenStopped = isAnimating
    }
  }

  var isAnimating: Bool = false

  lazy var indicatorView: UIActivityIndicatorView = {
    if #available(iOS 13, *) {
      return UIActivityIndicatorView(style: .large)
    } else {
      return UIActivityIndicatorView(style: .whiteLarge)
    }
  }()

  let loadingLabel = UILabel()
  var message: String? {
    didSet {
      loadingLabel.text = message
    }
  }

  func setup() {
    setupIndicatorView()
    setupTitleLabel()
  }
  func setupIndicatorView() {
    addSubview(indicatorView)
    indicatorView.alignEdgesToSuperView([.top])
    indicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
  }

  func setupTitleLabel() {
    addSubview(loadingLabel)
    loadingLabel.alignEdgesToSuperView([.left, .right], inset: UIEdgeInsets(top: 12, left: 32, bottom: 0, right: -32))
    loadingLabel.topAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: 30).isActive = true
    loadingLabel.textAlignment = .center
    loadingLabel.font = .boldSystemFont(ofSize: 16)
    loadingLabel.textColor = .lightText
    loadingLabel.numberOfLines = 0
    loadingLabel.text = message ?? ""
  }

  init() {
    super.init(frame: .zero)
    setup()
    bottomAnchor.constraint(equalTo: loadingLabel.bottomAnchor).isActive = true
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }

}

class ActivityIndicatorView: UIView {

  let activity: ActivityView
  var message: String? {
    didSet {
      activity.message = message
    }
  }

  var activityIndicatorColor: UIColor! = .clear {
    didSet {
      activity.activityIndicatorColor = activityIndicatorColor
    }
  }
  
  var hidesWhenStopped: Bool {
    set {
      activity.hidesWhenStopped = newValue
    }
    get {
      return activity.hidesWhenStopped
    }
  }

  func startAnimating() {
    guard let superview = self.superview else {
      return
    }
    isHidden = true
    superview.bringSubviewToFront(self)
    activity.startAnimating()
    setNeedsLayout()
  }

  func stopAnimating() {
    activity.stopAnimating()
    if hidesWhenStopped {
      isHidden = true
    }
  }

  open var isAnimating: Bool {
    return activity.isAnimating
  }

  var color: UIColor {
    get {
      return activity.color
    }
    set {
      activity.color = newValue
    }
  }

  init() {
    activity = ActivityViewWithLabel()
    super.init(frame: .zero)
    addSubview(activity)
    activity.translatesAutoresizingMaskIntoConstraints = false
    activity.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    activity.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    activity.backgroundColor = .clear
  }

  required init?(coder: NSCoder) {
    activity = ActivityViewWithLabel()
    super.init(coder: coder)
  }

}
