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

fileprivate extension Overlay {
    class Settings {
        static var alpha: (CGFloat) -> CGFloat = { _ in 0.16 }
        static var color: UIColor? = UIColor.white
    }
}

open class Overlay: UIView {
    public typealias DynamicAlpha = TraitObject<CGFloat>

    private var dynamicAlpha: DynamicAlpha = .init(dynamic: { _ in 0.0 })

    public func setAlpha(_ newValue: CGFloat) {
        self.setAlpha(.init(dynamic: { _ in newValue }))
    }

    public func setAlpha(_ dynamic: DynamicAlpha) {
        self.dynamicAlpha = dynamic
        self.reload()
    }

    static func orEmpty(_ view: UIView!) -> Overlay? {
        return view.subviews.first(where: { $0 is Overlay }) as? Overlay
    }

    static func orCreate(_ view: UIView!) -> Overlay {
        if let view = self.orEmpty(view) {
            return view
        }

        let overlay = Self.init()
        #if os(iOS)
        overlay.isExclusiveTouch = false
        #endif
        overlay.layer.zPosition = -1
        AddSubview(view).insertSubview(overlay, at: 0)

        Constraintable.activate(
            overlay.cbuild
                .edges
        )

        overlay.backgroundColor = Self.Settings.color
        overlay.layer.cornerRadius = view.layer.cornerRadius
        overlay.isOpaque = false
        overlay.reload()

        return overlay
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.reload()
    }

    private func reload() {
        self.alpha = Self.Settings.alpha(self.dynamicAlpha.traitDidChange(self.traitCollection))
    }
}

@objc public extension UIView {
    @IBInspectable
    var isOverlayHidden: Bool {
        get {
            return Overlay.orEmpty(self) == nil
        }

        set {
            if newValue {
                Overlay.orEmpty(self)?.removeFromSuperview()
            } else {
                _ = Overlay.orCreate(self)
            }
        }
    }

    @IBInspectable
    var overlayAlpha: CGFloat {
        get {
            return Overlay.orEmpty(self)?.alpha ?? 0
        }

        set {
            (newValue > 0 ? Overlay.orCreate(self) : Overlay.orEmpty(self))?.setAlpha(newValue)
        }
    }

    @IBInspectable
    var overlayColor: UIColor? {
        get {
            return Overlay.orEmpty(self)?.backgroundColor
        }

        set {
            Overlay.orCreate(self).backgroundColor = newValue
        }
    }

    var overlay: Overlay? {
        return Overlay.orEmpty(self)
    }
}

public extension UIView {
    static var overlayAlpha: (CGFloat) -> CGFloat {
        get {
            return Overlay.Settings.alpha
        }

        set {
            Overlay.Settings.alpha = newValue
        }
    }

    static var overlayColor: UIColor? {
        get {
            return Overlay.Settings.color
        }

        set {
            Overlay.Settings.color = newValue
        }
    }
}

public extension Overlay {
    static func defaultLayout(backgroundColor: UIColor) {
        let alphas = (self.zeroTilFiveAlpha + self.sixTilTwelveAlpha + self.thirteenTilTwentyFourAlpha)
        UIView.overlayColor = backgroundColor
        UIView.overlayAlpha = { alpha in
            alphas.first(where: {
                $0.0 == Int(alpha)
            })?.1 ?? 0.0
        }
    }

    private static var zeroTilFiveAlpha: [(Int, CGFloat)] {
        return [
            (1, 0.05),
            (2, 0.07),
            (3, 0.08),
            (4, 0.09),
            (5, 0.1)
        ]
    }

    private static var sixTilTwelveAlpha: [(Int, CGFloat)] {
        return (6 ... 12).enumerated().map {
            ($0.element, 0.11 + (CGFloat($0.offset) * 0.005))
        }
    }

    private static var thirteenTilTwentyFourAlpha: [(Int, CGFloat)] {
        let array = (12 ... 24).map { $0 }
        return Array((array.enumerated().map {
            ($0.element, 0.14 + (CGFloat($0.offset) * (0.01 / CGFloat(array.count - 1))))
        })[1..<array.count])
    }
}
