//
//  ParallaxHeader.swift
//  Movies
//
//  Created by Anshul Jain on 27/9/20.
//  Copyright © 2020 Anshul Jain. All rights reserved.
//

import Foundation
import UIKit

private let ParallaxHeaderObserverContext = UnsafeMutableRawPointer.allocate(
  byteCount: 4,
  alignment: 1
)

class ParallaxHeader: UIView {
  enum Mode {
    case center
    case fill
    case top
    case topFill
  }

  enum StickyViewPosition {
    case bottom
    case top
  }

  var mode: Mode
  var scrollView: UIScrollView
  var originalHeight: CGFloat
  var originalTopInset: CGFloat
  var containerView: UIView
  var contentView: UIView {
    didSet {
      oldValue.removeFromSuperview()
      contentView.translatesAutoresizingMaskIntoConstraints = false
      containerView.addSubview(contentView)
      setupContentViewMode()
    }
  }

  var insideTableView: Bool = false
  var progress: CGFloat? = nil
  var headerHeight: CGFloat? = nil
  var insetAwarePositionConstraint: NSLayoutConstraint? = nil
  var insetAwareSizeConstraint: NSLayoutConstraint? = nil


  init(scrollView: UIScrollView, contentView: UIView, mode: Mode, height: CGFloat) {
    self.mode = mode
    self.scrollView = scrollView
    self.originalHeight = height
    self.originalTopInset = scrollView.contentInset.top
    self.containerView = UIView(frame: CGRect.zero)
    self.containerView.clipsToBounds = true
    self.contentView = contentView
    super.init(frame: CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: height))
    self.containerView.frame = bounds
    containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    autoresizingMask = [.flexibleWidth]
    addSubview(containerView)
    contentView.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(contentView)
    setupContentViewMode()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func addContentViewModeFillConstraints() {
    contentView.trailingAnchor.constraint(equalTo: contentView.superview!.trailingAnchor).isActive = true
    contentView.leadingAnchor.constraint(equalTo: contentView.superview!.leadingAnchor).isActive = true

    insetAwarePositionConstraint = contentView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: originalTopInset / 2)
    insetAwarePositionConstraint?.isActive = true

    let heightConstraint = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: originalHeight)
    heightConstraint.priority = UILayoutPriority(999)
    heightConstraint.isActive = true

    insetAwareSizeConstraint = contentView.heightAnchor.constraint(equalTo: containerView.heightAnchor, constant: -self.originalTopInset)
    insetAwareSizeConstraint?.priority = .defaultHigh
    insetAwareSizeConstraint?.isActive = true
  }

  func addContentViewModeTopConstraints() {
    contentView.trailingAnchor.constraint(equalTo: contentView.superview!.trailingAnchor).isActive = true
    contentView.leadingAnchor.constraint(equalTo: contentView.superview!.leadingAnchor).isActive = true
    insetAwarePositionConstraint = contentView.topAnchor.constraint(equalTo: contentView.superview!.topAnchor, constant: originalTopInset)
    insetAwarePositionConstraint?.isActive = true

    let heightConstraint = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: originalHeight)
    heightConstraint.isActive = true
  }

  func addContentViewModeTopFillConstraints() {
    contentView.trailingAnchor.constraint(equalTo: contentView.superview!.trailingAnchor).isActive = true
    contentView.leadingAnchor.constraint(equalTo: contentView.superview!.leadingAnchor).isActive = true
    insetAwarePositionConstraint = contentView.topAnchor.constraint(equalTo: contentView.superview!.topAnchor, constant: originalTopInset)
    insetAwarePositionConstraint?.isActive = true

    let heightConstraint = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: originalHeight)
    heightConstraint.priority = .required
    heightConstraint.isActive = true
    insetAwareSizeConstraint = contentView.heightAnchor.constraint(equalTo: containerView.heightAnchor, constant: -self.originalTopInset)
    insetAwareSizeConstraint?.isActive = true
  }

  func addContentViewModeCenterConstraints() {
    contentView.trailingAnchor.constraint(equalTo: contentView.superview!.trailingAnchor).isActive = true
    contentView.leadingAnchor.constraint(equalTo: contentView.superview!.leadingAnchor).isActive = true
    contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: originalHeight).isActive = true

    insetAwarePositionConstraint = contentView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: originalTopInset / 2)
    insetAwarePositionConstraint?.isActive = true
  }


  override func willMove(toSuperview newSuperview: UIView?) {
    if let currentSuperView = superview as? UIScrollView, newSuperview == nil {
      let keyPath = NSStringFromSelector(#selector(getter: UITableView.contentOffset))
      currentSuperView.removeObserver(
        self,
        forKeyPath: keyPath,
        context: ParallaxHeaderObserverContext
      )
    }
  }

  func setupContentViewMode() {
    switch mode {
    case .fill:
      addContentViewModeFillConstraints()
    case .top:
      addContentViewModeTopConstraints()
    case .topFill:
      addContentViewModeTopFillConstraints()
    case .center:
      addContentViewModeCenterConstraints()
    }
  }

  override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
    guard context == ParallaxHeaderObserverContext, keyPath == NSStringFromSelector(#selector(getter: scrollView.contentOffset)) else {
      super.observeValue(
        forKeyPath: keyPath,
        of: object,
        change: change,
        context: context
      )
      return
    }
    originalTopInset = scrollView.contentOffset.y - (!insideTableView ? self.originalHeight : 0)
    switch mode {
    case .fill:
      insetAwarePositionConstraint?.constant = self.originalTopInset / 2
      insetAwareSizeConstraint?.constant = -self.originalTopInset
    case .top:
      self.insetAwarePositionConstraint?.constant = self.originalTopInset
    case .topFill:
      insetAwarePositionConstraint?.constant = self.originalTopInset
      insetAwareSizeConstraint?.constant = -self.originalTopInset
      if scrollView.contentOffset.y <= 0 {
        var rect = containerView.frame
        rect.origin.y = scrollView.contentOffset.y
        rect.size.height = -scrollView.contentOffset.y + bounds.height
        containerView.frame = rect
      } else {
        containerView.frame = bounds
      }
    case .center:
      insetAwarePositionConstraint?.constant = self.originalTopInset / 2
    }

    if !insideTableView {
      self.scrollView.contentOffset = CGPoint(x: 0, y: -self.scrollView.contentInset.top)
    }
  }

  var stickyViewContraints: [NSLayoutConstraint] = []
  var stickyViewPosition: StickyViewPosition = .bottom
  var stickyViewHeightConstraint: NSLayoutConstraint? = nil
  var stickyView: UIView? = nil {
    didSet {
      stickyView?.translatesAutoresizingMaskIntoConstraints = false
      containerView.insertSubview(stickyView!, aboveSubview: contentView)
      updateStickyViewConstraints()
    }
  }

  func setStickyView(_ stickyView: UIView, withHeight height: CGFloat)
  {
    self.stickyView = stickyView
    self.stickyViewHeightConstraint = stickyView.heightAnchor.constraint(equalToConstant: height)
  }

  func setStickyViewPosition(_ stickyViewPosition: StickyViewPosition)
  {
    self.stickyViewPosition = stickyViewPosition;
    updateStickyViewConstraints()
  }

  func updateStickyViewConstraints() {
    guard let stickyView = self.stickyView, stickyView.superview === self.containerView else { return }
    stickyView.removeConstraints(stickyViewContraints)
    containerView.removeConstraints(stickyViewContraints)

    stickyViewContraints = [NSLayoutConstraint]()
    stickyViewContraints.append(stickyView.trailingAnchor.constraint(equalTo: stickyView.superview!.trailingAnchor))
    stickyViewContraints.append(stickyView.leadingAnchor.constraint(equalTo: stickyView.superview!.leadingAnchor))

    switch stickyViewPosition {
    case .top:
      stickyViewContraints.append(stickyView.topAnchor.constraint(equalTo: stickyView.superview!.topAnchor))
      break;
    case .bottom:
      stickyViewContraints.append(stickyView.bottomAnchor.constraint(equalTo: stickyView.superview!.bottomAnchor))
      break;
    }
    for contraint in stickyViewContraints {
      contraint.isActive = true
    }
  }
}


class ParallaxTableView: UITableView {

  var parallaxHeader: ParallaxHeader? = nil {
    willSet {
      for view in subviews.compactMap({ $0 as? ParallaxHeader }) {
        view.removeFromSuperview()
      }
    }
    didSet {
      parallaxHeader?.insideTableView = true
      tableHeaderView = parallaxHeader
      parallaxHeader?.setNeedsLayout()
    }
  }

  func setParallaxHeaderView(view: UIView, mode: ParallaxHeader.Mode, height: CGFloat) {
    let parallaxHeader = ParallaxHeader(scrollView: self, contentView: view, mode: mode, height: height)
    self.parallaxHeader = parallaxHeader
    parallaxHeader.headerHeight = height
    shouldPositionParallaxHeader()
    if !parallaxHeader.insideTableView {
      var selfContentInset = self.contentInset
      selfContentInset.top += height

      self.contentInset = selfContentInset
      self.contentOffset = CGPoint(x: 0, y: -selfContentInset.top);
    }
    // Watch for inset changes
    let keyPath = NSStringFromSelector(#selector(getter: UITableView.contentOffset))
    self.addObserver(parallaxHeader,
      forKeyPath: keyPath,
      options: .new, context: ParallaxHeaderObserverContext)
  }

  func updateParallaxHeaderViewHeight(_ height: CGFloat) {
    var newContentInset: CGFloat = 0
    var selfContentInset = self.contentInset;

    guard let parallaxHeader = parallaxHeader, let headerHeight = parallaxHeader.headerHeight else { return }
    if height < headerHeight {
      newContentInset = headerHeight - height
      selfContentInset.top -= newContentInset
    } else {
      newContentInset = height - headerHeight
      selfContentInset.top += newContentInset
    }

    self.contentInset = selfContentInset;
    beginUpdates()
    parallaxHeader.headerHeight = height;
    tableHeaderView = parallaxHeader
    endUpdates()

  }

  func shouldPositionParallaxHeader() {
    positionTableViewParallaxHeader()
  }

  func positionTableViewParallaxHeader() {
    guard let parallaxHeader = parallaxHeader else { return }
    let height = contentOffset.y * -1
    let scaleProgress = fmaxf(0, Float(height / (parallaxHeader.originalHeight + parallaxHeader.originalTopInset)))
    parallaxHeader.progress = CGFloat(scaleProgress)

    if contentOffset.y < 0 {
      parallaxHeader.frame = CGRect(x: 0, y: self.contentOffset.y, width: self.frame.width, height: height)
    }

  }

}
