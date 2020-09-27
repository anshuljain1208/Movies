//
//  UIViewControllerExtension.swift
//  Movies
//
//  Created by Anshul Jain on 26/9/20.
//  Copyright © 2020 Anshul Jain. All rights reserved.
//

import UIKit

public extension UIViewController {

  static let tag = 30078

  @objc var activityIndicatorSuperView: UIView {
    return navigationController?.view ?? view
  }
  
  @objc var activityIndicatorBackgroundColor: UIColor {
    return UIColor.darkText.withAlphaComponent(0.7)
  }

  @objc var activityIndicatorColor: UIColor {
    return UIColor.lightText
  }

  internal var activityIndicatorView: ActivityIndicatorView {
    if let view = activityIndicatorSuperView.viewWithTag(UIViewController.tag) as? ActivityIndicatorView {
      return view
    }
    let activityIndicatorView = ActivityIndicatorView()
    activityIndicatorView.tag = UIViewController.tag
    activityIndicatorSuperView.addSubview(activityIndicatorView)
    activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    activityIndicatorView.alignEdgesToSuperView(.all)
    activityIndicatorView.activityIndicatorColor = activityIndicatorColor
    activityIndicatorView.backgroundColor = activityIndicatorBackgroundColor
    activityIndicatorView.isHidden = true
    activityIndicatorView.hidesWhenStopped = true
    return activityIndicatorView
  }

  var showActivityIndicaorView: Bool {
    set {
      if newValue {
        let activityIndicatorView = self.activityIndicatorView
        activityIndicatorSuperView.bringSubviewToFront(activityIndicatorView)
        activityIndicatorView.startAnimating()
        activityIndicatorView.isHidden = false
      } else {
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
      }
    }
    get {
      guard let activityIndicatorView = activityIndicatorSuperView.viewWithTag(UIViewController.tag) as? ActivityIndicatorView else {
        return false
      }
      return activityIndicatorView.isAnimating
    }
  }

  func showActivityIndicaorView(withMessage message: String) {
    showActivityIndicaorView = true
    activityIndicatorView.message = message;
  }

  func showError(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak alert] _ in alert?.dismiss(animated: true, completion: nil) }))
    present(alert, animated: true, completion: nil)
  }

}

class NavigationController: UINavigationController, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
    }
}
