//
//  AddSubview.swift
//  UIContainer
//
//  Created by brennobemoura on 06/02/20.
//

import Foundation
import UIKit

/// AddSubview class is a wrapper that will add the subview into superview, but checking the `translatesAutoresizingMaskIntoConstraints` and set to false if is needed
public struct AddSubview<Super: UIView> {
    fileprivate weak var superview: Super!

    /// Safety check superview and set `translatesAutoresizingMaskIntoConstraints` to false if needed
    public init(_ superview: Super) {
        self.superview = superview
        self.spSafe()
    }

    /// Safety check superview and set `translatesAutoresizingMaskIntoConstraints` to false if needed
    public init?(_ superview: Super?) {
        guard let superview = superview else {
            return nil
        }

        self.superview = superview
        self.spSafe()
    }

    private func spSafe() {
        self.superview.setAutoresizingToFalse()
    }
}

public extension AddSubview {
    /// Performs `addSubview(_:)` on `UIView`
    func addSubview(_ view: UIView) {
        self.safe(view)
        self.superview.addSubview(view)
    }

    /// Performs `insertSubview(_:, at:)` on `UIView`
    func insertSubview(_ view: UIView, at index: Int) {
        self.safe(view)
        self.superview.insertSubview(view, at: index)
    }

    /// Performs `insertSubview(_:, aboveSubview:)` on `UIView`
    func insertSubview(_ view: UIView, aboveSubview subview: UIView) {
        self.safe(view)
        self.superview.insertSubview(view, aboveSubview: subview)
    }

    /// Performs `insertSubview(_:, belowSubview:)` on `UIView`
    func insertSubview(_ view: UIView, belowSubview subview: UIView) {
        self.safe(view)
        self.superview.insertSubview(view, belowSubview: subview)
    }
}

public extension AddSubview where Super: UIStackView {
    /// Performs `addArrangedSubview(_:)` on `UIStackView`
    func addArrangedSubview(_ view: UIView!) {
        self.safe(view)
        self.superview.addArrangedSubview(view)
    }

    /// Performs `insertArrangedSubview(_:, at:)` on `UIStackView`
    func insertArrangedSubview(_ view: UIView, at index: Int) {
        self.safe(view)
        self.superview.insertArrangedSubview(view, at: index)
    }
}

private extension AddSubview {
    func safe(_ view: UIView) {
        view.setAutoresizingToFalse()
        if view === self.superview {
            fatalError()
        }
    }
}

private extension UIView {
    func setAutoresizingToFalse() {
        switch self.next {
        case is UIViewController:
            return
        case is UITableViewCell:
            return
        case is UICollectionViewCell:
            return
        case is UITableViewHeaderFooterView:
            return
        case is UICollectionReusableView:
            return
        default:
            break
        }

        guard !(self is UIWindow) else {
            return
        }

        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
