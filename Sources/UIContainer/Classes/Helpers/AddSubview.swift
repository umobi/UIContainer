//
// Copyright (c) 2019-Present Umobi - https://github.com/umobi
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
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
        self.superview.setAutoresizingToFalse(.superview)
    }
}

enum AddSubviewMode {
    case superview
    case subview
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
        view.setAutoresizingToFalse(.subview)
        if view === self.superview {
            fatalError()
        }
    }
}

private extension UIView {
    func setAutoresizingToFalse(_ mode: AddSubviewMode) {
        if case .superview = mode {
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
            case is UIVisualEffectView:
                return
            default:
                break
            }

            guard !(self is UIWindow) else {
                return
            }
        }

        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
