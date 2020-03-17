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

    private weak var contentView: UIView!
    public var axis: Axis {
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
                    .equal.to(self.anchor.width)
                    .priority(UILayoutPriority.required.rawValue),

                contentView.anchor
                    .height
                    .equal.to(self.anchor.height)
                    .priority(UILayoutPriority.fittingSizeLevel.rawValue)
            )
        case .horizontal:
            activate(
                contentView.anchor
                    .width
                    .equal.to(self.anchor.width)
                    .priority(UILayoutPriority.fittingSizeLevel.rawValue),

                contentView.anchor
                    .height
                    .equal.to(self.anchor.height)
                    .priority(UILayoutPriority.required.rawValue)
            )

        case .auto(let vertical, let horizontal):
            activate(
                contentView.anchor
                    .width
                    .equal.to(self.anchor.width)
                    .priority(vertical.rawValue),

                contentView.anchor
                    .height
                    .equal.to(self.anchor.height)
                    .priority(horizontal.rawValue)
            )
        }
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
