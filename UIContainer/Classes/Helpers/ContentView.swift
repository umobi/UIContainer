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

open class ContentView: View {

    weak var view: UIView!
    public required init(_ view: UIView!, contentMode: UIView.ContentMode, priority: UILayoutPriority = .required) {
        super.init(frame: .zero)
        AddSubview(self).addSubview(view)
        self.view = view

        self.reload(contentMode: contentMode, priority: priority)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func reload(contentMode: UIView.ContentMode, priority: UILayoutPriority) {
        let view: UIView! = self.view
        NSLayoutConstraint.deactivate(view.anchor.constraints())

        switch contentMode {
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
    func apply(contentMode: UIView.ContentMode) {
        self.reload(contentMode: contentMode, priority: .defaultHigh)
    }

    func apply(priority: UILayoutPriority) {
        self.reload(contentMode: contentMode, priority: priority)
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
