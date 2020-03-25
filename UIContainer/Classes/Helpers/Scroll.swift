//
//  Scroll.swift
//  UIContainer
//
//  Created by brennobemoura on 08/11/19.
//

import Foundation
import UIKit
import EasyAnchor

public struct Constraint {
    public static func deactivate(_ array: [NSLayoutConstraint]) {
        NSLayoutConstraint.deactivate(array)
    }

    public static func deactivate(_ anchors: Anchor...) {
        self.deactivate(anchors.reduce([]) { $0 + $1.findByContent() })
    }
}

open class ScrollView: UIScrollView, Content {

    public enum Axis {
        case vertical
        case horizontal
        case auto(vertical: UILayoutPriority, horizontal: UILayoutPriority)
    }

    public enum Margin {
        case safeArea
        case bounds
    }

    private weak var contentView: UIView!
    public var axis: Axis {
        didSet {
            self.reloadContentLayout()
        }
    }

    public var verticalMargin: Margin = .safeArea {
        didSet {
            self.reloadContentLayout()
        }
    }

    public var horizontalMargin: Margin = .bounds {
        didSet {
            self.reloadContentLayout()
        }
    }

    open override var contentInset: UIEdgeInsets {
        didSet {
            self.reloadContentLayout()
        }
    }

    public required init(_ view: UIView, axis: Axis = .vertical) {
        self.axis = axis
        super.init(frame: .zero)

        self.addContent(view)
    }

    public required init(axis: Axis = .vertical) {
        self.axis = axis
        super.init(frame: .zero)
    }

    public func addContent(_ view: UIView) {
        let contentView = ContentView(view)
        AddSubview(self).addSubview(contentView)
        self.contentView = contentView

        activate(
            contentView.anchor
                .edges
        )

        self.reloadContentLayout()
    }

    public func reloadContentLayout() {
        if let width = self.contentView.anchor.width.equal.to(self.anchor.width).findByContent().first {
            Constraint.deactivate([width])
        }

        if let height = self.contentView.anchor.height.equal.to(self.anchor.height).findByContent().first {
            Constraint.deactivate([height])
        }

        switch axis {
        case .vertical:
            activate(
                contentView.anchor
                    .width
                    .equal.to(self.widthMarginAnchor)
                    .priority(UILayoutPriority.required.rawValue)
                    .constant(-self.horizontalOffset),

                contentView.anchor
                    .height
                    .equal.to(self.heightMarginAnchor)
                    .priority(UILayoutPriority.fittingSizeLevel.rawValue)
                    .constant(-self.verticalOffset)
            )
        case .horizontal:
            activate(
                contentView.anchor
                    .width
                    .equal.to(self.widthMarginAnchor)
                    .priority(UILayoutPriority.fittingSizeLevel.rawValue)
                    .constant(-self.horizontalOffset),

                contentView.anchor
                    .height
                    .equal.to(self.heightMarginAnchor)
                    .priority(UILayoutPriority.required.rawValue)
                    .constant(-self.verticalOffset)
            )

        case .auto(let vertical, let horizontal):
            activate(
                contentView.anchor
                    .width
                    .equal.to(self.widthMarginAnchor)
                    .priority(vertical.rawValue)
                    .constant(-self.horizontalOffset),

                contentView.anchor
                    .height
                    .equal.to(self.heightMarginAnchor)
                    .priority(horizontal.rawValue)
                    .constant(-self.verticalOffset)
            )
        }
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ScrollView {
    var heightMarginAnchor: Anchor {
        switch self.verticalMargin {
        case .bounds:
            return self.anchor.height
        case .safeArea:
            if #available(iOS 11, tvOS 11, *) {
                return self.safeAreaLayoutGuide.anchor.height
            }

            return self.layoutMarginsGuide.anchor.height
        }
    }

    var widthMarginAnchor: Anchor {
        switch self.verticalMargin {
        case .bounds:
            return self.anchor.width
        case .safeArea:
            if #available(iOS 11, tvOS 11, *) {
                return self.safeAreaLayoutGuide.anchor.width
            }

            return self.layoutMarginsGuide.anchor.width
        }
    }
}

private extension ScrollView {
    var verticalOffset: CGFloat {
        return self.contentInset.top + self.contentInset.bottom
    }

    var horizontalOffset: CGFloat {
        return self.contentInset.left + self.contentInset.right
    }
}

private extension ScrollView {
    class ContentView: UIView {
        weak var view: UIView!

        convenience init(_ view: UIView) {
            self.init(frame: .zero)
            self.view = view

            AddSubview(self).addSubview(view)

            activate(
                view.anchor
                    .edges
            )
        }
    }
}
