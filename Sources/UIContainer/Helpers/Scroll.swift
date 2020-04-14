//
//  Scroll.swift
//  UIContainer
//
//  Created by brennobemoura on 08/11/19.
//

import Foundation
import UIKit
import ConstraintBuilder

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

        Constraintable.activate(
            contentView.cbuild
                .edges
        )

        self.reloadContentLayout()
    }

    public func reloadContentLayout() {
        Constraintable.deactivate(
            self.contentView.cbuild.width.equalTo(self.cbuild.width),
            self.contentView.cbuild.height.equalTo(self.cbuild.height)
        )

        switch axis {
        case .vertical:
            Constraintable.activate(
                contentView.cbuild
                    .width
                    .equalTo(self.widthMarginAnchor)
                    .priority(.required)
                    .constant(-self.horizontalOffset),

                contentView.cbuild
                    .height
                    .equalTo(self.heightMarginAnchor)
                    .priority(.fittingSizeLevel)
                    .constant(-self.verticalOffset)
            )
        case .horizontal:
            Constraintable.activate(
                contentView.cbuild
                    .width
                    .equalTo(self.widthMarginAnchor)
                    .priority(.fittingSizeLevel)
                    .constant(-self.horizontalOffset),

                contentView.cbuild
                    .height
                    .equalTo(self.heightMarginAnchor)
                    .priority(.required)
                    .constant(-self.verticalOffset)
            )

        case .auto(let vertical, let horizontal):
            Constraintable.activate(
                contentView.cbuild
                    .width
                    .equalTo(self.widthMarginAnchor)
                    .priority(vertical)
                    .constant(-self.horizontalOffset),

                contentView.cbuild
                    .height
                    .equalTo(self.heightMarginAnchor)
                    .priority(horizontal)
                    .constant(-self.verticalOffset)
            )
        }
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ScrollView {
    var heightMarginAnchor: ConstraintDimension {
        switch self.verticalMargin {
        case .bounds:
            return self.cbuild.height
        case .safeArea:
            if #available(iOS 11, tvOS 11, *) {
                return self.safeAreaLayoutGuide.cbuild.height
            }

            if case .vertical = self.axis {
                return self.layoutMarginsGuide.cbuild.height
            }

            return self.cbuild.height
        }
    }

    var widthMarginAnchor: ConstraintDimension {
        switch self.verticalMargin {
        case .bounds:
            return self.cbuild.width
        case .safeArea:
            if #available(iOS 11, tvOS 11, *) {
                return self.safeAreaLayoutGuide.cbuild.width
            }

            if case .horizontal = self.axis {
                return self.layoutMarginsGuide.cbuild.width
            }

            return self.cbuild.width
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

            Constraintable.activate(
                view.cbuild
                    .edges
            )
        }
    }
}
