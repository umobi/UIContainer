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
import ConstraintBuilder

@available(*, deprecated, message: "use UICContentView from UICreator")
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
            Constraintable.deactivate(
                view.cbuild
                    .bottom,

                view.cbuild
                    .centerX
                    .equalTo(self.cbuild.centerX),

                view.cbuild
                    .top
                    .greaterThanOrEqualTo(0),

                view.cbuild
                    .trailing
                    .leading
                    .greaterThanOrEqualTo(0)
            )

        case .bottomLeft:
            Constraintable.deactivate(
                view.cbuild
                    .bottom
                    .equalTo(0),

                view.cbuild
                    .leading
                    .equalTo(0),

                view.cbuild
                    .top
                    .greaterThanOrEqualTo(0),

                view.cbuild
                    .trailing
                    .greaterThanOrEqualTo(0)
            )

        case .bottomRight:
            Constraintable.deactivate(
                view.cbuild
                    .bottom
                    .equalTo(0),

                view.cbuild
                    .trailing
                    .equalTo(0),

                view.cbuild
                    .top
                    .greaterThanOrEqualTo(0),

                view.cbuild
                    .leading
                    .greaterThanOrEqualTo(0)
            )

        case .center:
            Constraintable.deactivate(
                view.cbuild
                    .center
                    .equalTo(self.cbuild.center),

                view.cbuild
                    .top
                    .bottom
                    .greaterThanOrEqualTo(0),

                view.cbuild
                    .trailing
                    .leading
                    .greaterThanOrEqualTo(0)
            )

        case .left:
            Constraintable.deactivate(
                view.cbuild
                    .top
                    .bottom
                    .greaterThanOrEqualTo(0),

                view.cbuild
                    .trailing
                    .greaterThanOrEqualTo(0),

                view.cbuild
                    .leading
                    .equalTo(0),

                view.cbuild
                    .centerY
                    .equalTo(self.cbuild.centerY)
            )

        case .right:
            Constraintable.deactivate(
                view.cbuild
                    .top
                    .bottom
                    .greaterThanOrEqualTo(0),

                view.cbuild
                    .leading
                    .greaterThanOrEqualTo(0),

                view.cbuild
                    .trailing
                    .equalTo(0),

                view.cbuild
                    .centerY
                    .equalTo(self.cbuild.centerY)
            )

        case .top:
            Constraintable.deactivate(
                view.cbuild
                    .top
                    .bottom
                    .equalTo(0),

                view.cbuild
                    .leading
                    .trailing
                    .greaterThanOrEqualTo(0),

                view.cbuild
                    .centerX
                    .equalTo(self.cbuild.centerX)
            )

        case .topLeft:
            Constraintable.deactivate(
                view.cbuild
                    .top
                    .equalTo(0),

                view.cbuild
                    .leading
                    .equalTo(0),

                view.cbuild
                    .bottom
                    .greaterThanOrEqualTo(0),

                view.cbuild
                    .trailing
                    .greaterThanOrEqualTo(0)
            )

        case .topRight:
            Constraintable.deactivate(
                view.cbuild
                    .top
                    .equalTo(0),

                view.cbuild
                    .trailing
                    .equalTo(0),

                view.cbuild
                    .bottom
                    .greaterThanOrEqualTo(0),

                view.cbuild
                    .leading
                    .greaterThanOrEqualTo(0)
            )
        case .scaleAspectFill: fallthrough
        case .scaleToFill: fallthrough
        case .redraw: fallthrough
        case .scaleAspectFit: fallthrough
        @unknown default:
            Constraintable.deactivate(
                view.cbuild
                    .top
                    .bottom,

                view.cbuild
                    .leading
                    .trailing
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
            Constraintable.activate(
                view.cbuild
                    .bottom
                    .priority(priority),

                view.cbuild
                    .centerX
                    .equalTo(self.cbuild.centerX)
                    .priority(priority),

                view.cbuild
                    .top
                    .greaterThanOrEqualTo(0)
                    .priority(priority),

                view.cbuild
                    .leading
                    .trailing
                    .greaterThanOrEqualTo(0)
                    .priority(priority)
            )
        case .bottomLeft:
            Constraintable.activate(
                view.cbuild
                    .bottom
                    .equalTo(0)
                    .priority(priority),

                view.cbuild
                    .leading
                    .equalTo(0)
                    .priority(priority),

                view.cbuild
                    .top
                    .greaterThanOrEqualTo(0)
                    .priority(priority),

                view.cbuild
                    .trailing
                    .greaterThanOrEqualTo(0)
                    .priority(priority)
            )

        case .bottomRight:
            Constraintable.activate(
                view.cbuild
                    .bottom
                    .equalTo(0)
                    .priority(priority),

                view.cbuild
                    .trailing
                    .equalTo(0)
                    .priority(priority),

                view.cbuild
                    .top
                    .greaterThanOrEqualTo(0)
                    .priority(priority),

                view.cbuild
                    .leading
                    .greaterThanOrEqualTo(0)
                    .priority(priority)
            )
        case .center:
            Constraintable.activate(
                view.cbuild
                    .center
                    .equalTo(self.cbuild.center)
                    .priority(priority),

                view.cbuild
                    .top
                    .bottom
                    .greaterThanOrEqualTo(0)
                    .priority(priority),

                view.cbuild
                    .leading
                    .trailing
                    .greaterThanOrEqualTo(0)
                    .priority(priority)
            )

        case .left:
            Constraintable.activate(
                view.cbuild
                    .top
                    .bottom
                    .greaterThanOrEqualTo(0)
                    .priority(priority),

                view.cbuild
                    .trailing
                    .greaterThanOrEqualTo(0)
                    .priority(priority),

                view.cbuild
                    .leading
                    .equalTo(0)
                    .priority(priority),

                view.cbuild
                    .centerY
                    .equalTo(self.cbuild.centerY)
                    .priority(priority)
            )

        case .right:
            Constraintable.activate(
                view.cbuild
                    .top
                    .bottom
                    .greaterThanOrEqualTo(0)
                    .priority(priority),

                view.cbuild
                    .leading
                    .greaterThanOrEqualTo(0)
                    .priority(priority),

                view.cbuild
                    .trailing
                    .equalTo(0)
                    .priority(priority),

                view.cbuild
                    .centerY
                    .equalTo(self.cbuild.centerY)
                    .priority(priority)
            )

        case .top:
            Constraintable.activate(
                view.cbuild
                    .top
                    .equalTo(0)
                    .priority(priority),

                view.cbuild
                    .bottom
                    .greaterThanOrEqualTo(0)
                    .priority(priority),

                view.cbuild
                    .leading
                    .trailing
                    .greaterThanOrEqualTo(0)
                    .priority(priority),

                view.cbuild
                    .centerX
                    .equalTo(self.cbuild.centerX)
                    .priority(priority)
            )

        case .topLeft:
            Constraintable.activate(
                view.cbuild
                    .top
                    .equalTo(0)
                    .priority(priority),

                view.cbuild
                    .leading
                    .equalTo(0)
                    .priority(priority),

                view.cbuild
                    .bottom
                    .greaterThanOrEqualTo(0)
                    .priority(priority),

                view.cbuild
                    .trailing
                    .greaterThanOrEqualTo(0)
                    .priority(priority)
            )

        case .topRight:
            Constraintable.activate(
                view.cbuild
                    .top
                    .equalTo(0)
                    .priority(priority),

                view.cbuild
                    .trailing
                    .equalTo(0)
                    .priority(priority),

                view.cbuild
                    .bottom
                    .greaterThanOrEqualTo(0)
                    .priority(priority),

                view.cbuild
                    .leading
                    .greaterThanOrEqualTo(0)
                    .priority(priority)
            )
        case .scaleAspectFill: fallthrough
        case .scaleToFill: fallthrough
        case .redraw: fallthrough
        case .scaleAspectFit: fallthrough
        @unknown default:
            Constraintable.activate(
                view.cbuild
                    .edges
            )
        }
    }
}

@available(*, deprecated, message: "will be unavailable")
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
