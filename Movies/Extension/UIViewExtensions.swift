//
//  UIViewExtensions.swift
//  Movies
//
//  Created by Anshul Jain on 26/9/20.
//  Copyright © 2020 Anshul Jain. All rights reserved.
//

import UIKit

extension UIView {

    /// Search the subviews of `self` for a view of type `T`.
    ///
    /// This function performs a breadth-first search of all the subviews of `self` and returns the first subview it finds, or `nil` if none is found.
    ///
    /// - Returns: A view of type `T` if one is found.
    func findSubview<T: UIView>() -> T? {

        func find(from subviews: [UIView]) -> T? {
            return subviews.first { $0 is T } as? T
        }

        var subviews = self.subviews
        while subviews.count > 0 {
            if let found: T = find(from: subviews) {
                return found
            }
            subviews = subviews.flatMap { $0.subviews }
        }

        return nil
    }
}

public protocol Anchors {
    var leadingAnchor: NSLayoutXAxisAnchor { get }

    var trailingAnchor: NSLayoutXAxisAnchor { get }

    var leftAnchor: NSLayoutXAxisAnchor { get }

    var rightAnchor: NSLayoutXAxisAnchor { get }

    var topAnchor: NSLayoutYAxisAnchor { get }

    var bottomAnchor: NSLayoutYAxisAnchor { get }

    var widthAnchor: NSLayoutDimension { get }

    var heightAnchor: NSLayoutDimension { get }

    var centerXAnchor: NSLayoutXAxisAnchor { get }

    var centerYAnchor: NSLayoutYAxisAnchor { get }

}

extension UILayoutGuide: Anchors {

}

extension UIView: Anchors {

    @discardableResult
    public func alignToTopEdge(constant: CGFloat = 0, guide: Anchors? = nil) -> NSLayoutConstraint {
        let guide: Anchors = guide ?? superview!
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = topAnchor.constraint(equalTo: guide.topAnchor, constant: constant)
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    public func alignToBottonEdge(constant: CGFloat = 0, guide: Anchors? = nil) -> NSLayoutConstraint {
        let guide: Anchors = guide ?? superview!
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: constant)
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    public func alignToLeadingEdge(constant: CGFloat = 0, guide: Anchors? = nil) -> NSLayoutConstraint {
        let guide: Anchors = guide ?? superview!
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: constant)
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    public func alignToTrailingEdge(constant: CGFloat = 0, guide: Anchors? = nil) -> NSLayoutConstraint {
        let guide: Anchors = guide ?? superview!
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: constant)
        constraint.isActive = true
        return constraint
    }

    @discardableResult

    public func alignEdgesToGuide(_ edges: UIRectEdge, inset: UIEdgeInsets = .zero, guide: Anchors? = nil) -> [NSLayoutConstraint] {
        var constarints = [NSLayoutConstraint]()
        guard edges.contains(.all) == false else {
            constarints.append(alignToTopEdge(constant: inset.top, guide: guide))
            constarints.append(alignToBottonEdge(constant: inset.bottom, guide: guide))
            constarints.append(alignToLeadingEdge(constant: inset.left, guide: guide))
            constarints.append(alignToTrailingEdge(constant: inset.right, guide: guide))
            return constarints
        }
        if edges.contains(.top) {
            constarints.append(alignToTopEdge(constant: inset.top, guide: guide))
        }
        if edges.contains(.bottom) {
            constarints.append(alignToBottonEdge(constant: inset.bottom, guide: guide))
        }
        if edges.contains(.left) {
            constarints.append(alignToLeadingEdge(constant: inset.left, guide: guide))
        }
        if edges.contains(.right) {
            constarints.append(alignToTrailingEdge(constant: inset.right, guide: guide))
        }
        return constarints
    }

    @discardableResult
    public func alignEdgesToSuperView(_ edges: UIRectEdge, inset: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        return alignEdgesToGuide(edges, inset: inset, guide: superview!)
    }

    @discardableResult
    public func alignCenterXToSuperView(constant: CGFloat = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = centerXAnchor.constraint(equalTo: superview!.centerXAnchor, constant: constant)
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    public func alignCenterYToSuperView(constant: CGFloat = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = centerYAnchor.constraint(equalTo: superview!.centerYAnchor, constant: constant)
        constraint.isActive = true
        return constraint
    }


    @discardableResult
    public func alignHorzontaEdgesToSuperView(_ inset: UIEdgeInsets = .zero, guide: Anchors? = nil) -> [NSLayoutConstraint] {
        var constarints = [NSLayoutConstraint]()
        constarints.append(alignToLeadingEdge(constant: inset.left, guide: superview!))
        constarints.append(alignToTrailingEdge(constant: inset.right, guide: superview!))
        return constarints
    }

}
