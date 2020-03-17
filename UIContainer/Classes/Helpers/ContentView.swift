//
//  Dashed.swift
//  Fujioka
//
//  Created by brennobemoura on 09/10/19.
//  Copyright © 2019 Umobi. All rights reserved.
//

import Foundation
import UIKit
import EasyAnchor

open class ContentView: View, Content {
    public var priority: UILayoutPriority {
        didSet {
            self.reloadContentLayout()
        }
    }

    public var layoutMode: UIView.ContentMode {
        didSet {
            self.reloadContentLayout(oldValue)
        }
    }

    weak var view: UIView?
    public required init(_ view: UIView!, contentMode: UIView.ContentMode, priority: UILayoutPriority = .required) {
        self.priority = priority
        self.layoutMode = contentMode
        super.init(frame: .zero)
        self.addContent(view)
    }

    public required init(contentMode: UIView.ContentMode, priority: UILayoutPriority = .required) {
        self.priority = priority
        self.layoutMode = contentMode
        super.init(frame: .zero)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(frame: CGRect) {
        self.priority = .defaultHigh
        self.layoutMode = .scaleToFill
        super.init(frame: frame)
    }

    public func addContent(_ view: UIView) {
        AddSubview(self).addSubview(view)
        self.view = view

        self.reloadContentLayout()
    }

    private func removeConstraints(_ oldValue: UIView.ContentMode) {
        guard let view = self.view else {
            return
        }

        switch oldValue {
        case .bottom:
            Constraint.deactivate(
                view.anchor
                    .bottom,

                view.anchor
                    .centerX
                    .equal.to(self.anchor.centerX),

                view.anchor
                    .top
                    .leading
                    .greaterThanOrEqual,

                view.anchor
                    .trailing
                    .lessThanOrEqual
            )

        case .bottomLeft:
            Constraint.deactivate(
                view.anchor
                    .bottom
                    .leading
                    .equal,

                view.anchor
                    .top
                    .lessThanOrEqual,

                view.anchor
                    .trailing
                    .lessThanOrEqual
            )

        case .bottomRight:
            Constraint.deactivate(
                view.anchor
                    .bottom
                    .trailing
                    .equal,

                view.anchor
                    .top
                    .leading
                    .greaterThanOrEqual
            )

        case .center:
            Constraint.deactivate(
                view.anchor
                    .center
                    .equal.to(self.anchor.center),

                view.anchor
                    .top
                    .leading
                    .greaterThanOrEqual,

                view.anchor
                    .bottom
                    .trailing
                    .lessThanOrEqual
            )

        case .left:
            Constraint.deactivate(
                view.anchor
                    .top
                    .greaterThanOrEqual,

                view.anchor
                    .bottom
                    .trailing
                    .lessThanOrEqual,

                view.anchor
                    .leading
                    .equal,

                view.anchor
                    .centerY
                    .equal.to(self.anchor.centerY)
            )

        case .right:
            Constraint.deactivate(
                view.anchor
                    .top
                    .leading
                    .greaterThanOrEqual,

                view.anchor
                    .bottom
                    .lessThanOrEqual,

                view.anchor
                    .trailing
                    .equal,

                view.anchor
                    .centerY
                    .equal.to(self.anchor.centerY)
            )

        case .top:
            Constraint.deactivate(
                view.anchor
                    .top
                    .equal,

                view.anchor
                    .bottom
                    .trailing
                    .lessThanOrEqual,

                view.anchor
                    .leading
                    .greaterThanOrEqual,

                view.anchor
                    .centerX
                    .equal.to(self.anchor.centerX)
            )

        case .topLeft:
            Constraint.deactivate(
                view.anchor
                    .top
                    .leading
                    .equal,

                view.anchor
                    .bottom
                    .trailing
                    .lessThanOrEqual
            )

        case .topRight:
            Constraint.deactivate(
                view.anchor
                    .top
                    .trailing
                    .equal,

                view.anchor
                    .bottom
                    .lessThanOrEqual,

                view.anchor
                    .leading
                    .greaterThanOrEqual
            )
        case .scaleAspectFill: fallthrough
        case .scaleToFill: fallthrough
        case .redraw: fallthrough
        case .scaleAspectFit: fallthrough
        @unknown default:
            Constraint.deactivate(
                view.anchor
                    .edges
            )
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public func reloadContentLayout() {
        self.reloadContentLayout(nil)
    }

    private func reloadContentLayout(_ oldLayoutMode: UIView.ContentMode?) {
        guard let view = self.view else {
            return
        }

        self.removeConstraints(oldLayoutMode ?? self.layoutMode)

        switch self.layoutMode {
        case .bottom:
            activate(
                view.anchor
                    .bottom
                    .priority(priority.rawValue),

                view.anchor
                    .centerX
                    .equal.to(self.anchor.centerX)
                    .priority(priority.rawValue),

                view.anchor
                    .top
                    .leading
                    .greaterThanOrEqual
                    .constant(0)
                    .priority(priority.rawValue),

                view.anchor
                    .trailing
                    .lessThanOrEqual
                    .constant(0)
                    .priority(priority.rawValue)
            )
        case .bottomLeft:
            activate(
                view.anchor
                    .bottom
                    .leading
                    .equal
                    .constant(0)
                    .priority(priority.rawValue),

                view.anchor
                    .top
                    .lessThanOrEqual
                    .constant(0)
                    .priority(priority.rawValue),

                view.anchor
                    .trailing
                    .lessThanOrEqual
                    .constant(0)
                    .priority(priority.rawValue)
            )

        case .bottomRight:
            activate(
                view.anchor
                    .bottom
                    .trailing
                    .equal
                    .constant(0)
                    .priority(priority.rawValue),

                view.anchor
                    .top
                    .leading
                    .greaterThanOrEqual
                    .constant(0)
                    .priority(priority.rawValue)
            )
        case .center:
            activate(
                view.anchor
                    .center
                    .equal.to(self.anchor.center)
                    .priority(priority.rawValue),

                view.anchor
                    .top
                    .leading
                    .greaterThanOrEqual
                    .constant(0)
                    .priority(priority.rawValue),

                view.anchor
                    .bottom
                    .trailing
                    .lessThanOrEqual
                    .constant(0)
                    .priority(priority.rawValue)
            )

        case .left:
            activate(
                view.anchor
                    .top
                    .greaterThanOrEqual
                    .constant(0)
                    .priority(priority.rawValue),

                view.anchor
                    .bottom
                    .trailing
                    .lessThanOrEqual
                    .constant(0)
                    .priority(priority.rawValue),

                view.anchor
                    .leading
                    .equal
                    .constant(0)
                    .priority(priority.rawValue),

                view.anchor
                    .centerY
                    .equal.to(self.anchor.centerY)
                    .priority(priority.rawValue)
            )

        case .right:
            activate(
                view.anchor
                    .top
                    .leading
                    .greaterThanOrEqual
                    .constant(0)
                    .priority(priority.rawValue),

                view.anchor
                    .bottom
                    .lessThanOrEqual
                    .constant(0)
                    .priority(priority.rawValue),

                view.anchor
                    .trailing
                    .equal
                    .constant(0)
                    .priority(priority.rawValue),

                view.anchor
                    .centerY
                    .equal.to(self.anchor.centerY)
                    .priority(priority.rawValue)
            )

        case .top:
            activate(
                view.anchor
                    .top
                    .equal
                    .constant(0)
                    .priority(priority.rawValue),

                view.anchor
                    .bottom
                    .trailing
                    .lessThanOrEqual
                    .constant(0)
                    .priority(priority.rawValue),

                view.anchor
                    .leading
                    .greaterThanOrEqual
                    .constant(0)
                    .priority(priority.rawValue),

                view.anchor
                    .centerX
                    .equal.to(self.anchor.centerX)
                    .priority(priority.rawValue)
            )

        case .topLeft:
            activate(
                view.anchor
                    .top
                    .leading
                    .equal
                    .constant(0)
                    .priority(priority.rawValue),

                view.anchor
                    .bottom
                    .trailing
                    .lessThanOrEqual
                    .constant(0)
                    .priority(priority.rawValue)
            )

        case .topRight:
            activate(
                view.anchor
                    .top
                    .trailing
                    .equal
                    .constant(0)
                    .priority(priority.rawValue),

                view.anchor
                    .bottom
                    .lessThanOrEqual
                    .constant(0)
                    .priority(priority.rawValue),

                view.anchor
                    .leading
                    .greaterThanOrEqual
                    .constant(0)
                    .priority(priority.rawValue)
            )
        case .scaleAspectFill: fallthrough
        case .scaleToFill: fallthrough
        case .redraw: fallthrough
        case .scaleAspectFit: fallthrough
        @unknown default:
            activate(
                view.anchor
                    .edges
            )
        }
    }
}

public extension ContentView {
    class func Center(_ view: UIView) -> ContentView {
        return .init(view, contentMode: .center)
    }
    
    class func TopLeft(_ view: UIView) -> ContentView {
        return .init(view, contentMode: .topLeft)
    }
    
    class func Top(_ view: UIView) -> ContentView {
        return .init(view, contentMode: .top)
    }
    
    class func TopRight(_ view: UIView) -> ContentView {
        return .init(view, contentMode: .topRight)
    }
    
    class func Left(_ view: UIView) -> ContentView {
        return .init(view, contentMode: .left)
    }
    
    class func Right(_ view: UIView) -> ContentView {
        return .init(view, contentMode: .right)
    }
    
    class func BottomLeft(_ view: UIView) -> ContentView {
        return .init(view, contentMode: .bottomLeft)
    }
    
    class func Bottom(_ view: UIView) -> ContentView {
        return .init(view, contentMode: .bottom)
    }
    
    class func BottomRight(_ view: UIView) -> ContentView {
        return .init(view, contentMode: .bottomRight)
    }
}
