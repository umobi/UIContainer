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

public protocol ColorDynamicType {
    typealias ColorTrait = TraitObject<UIColor>
    associatedtype RawValue: ColorType

    static var darkSettings: (grayScaleConstant: CGFloat, rgbConstant: CGFloat) { get }
    var rawValue: RawValue { get }
    var trait: ColorTrait { get }
    var color: UIColor { get }

    var onDarkMode: ((UIColor) -> UIColor)? { get }

    init(_ rawValue: RawValue)
}

public protocol ColorDynamicProvider: ColorType {
    associatedtype Dynamic: ColorDynamicType where Dynamic.RawValue == Self
    var dynamic: Dynamic { get }
}

public extension ColorDynamicProvider {
    var dynamic: Self.Dynamic {
        return .init(self)
    }
}

public extension ColorDynamicProvider {
    static func dynamic(_ color: Self, onDark darkHandler: ((UIColor) -> UIColor)?) -> UIColor {
        return .dynamic(onLight: color.color, onDark: darkHandler?(color.color) ?? color.dynamic.color)
    }
}

public extension UIColor {
    static func dynamic(onLight lightColor: UIColor, onDark darkColor: UIColor) -> UIColor {
        if #available(iOS 13, tvOS 13, *) {
            return UIColor { (traits) -> UIColor in
                return traits.userInterfaceStyle == .dark ?
                    darkColor :
                    lightColor
            }
        }

        return lightColor
    }
}

public extension ColorDynamicType {
    var color: UIColor {
        return self.trait.asColor
    }

    var trait: ColorTrait {
        return { color in
            return .init { trait -> UIColor in
                guard #available(iOS 12.0, *) else {
                    return color
                }

                switch trait.userInterfaceStyle {
                case .dark:
                    return self.darkColor(color)
                default:
                    return color
                }
            }
        }(self.rawValue.color)
    }
}

public extension ColorDynamicType {
    var onDarkMode: ((UIColor) -> UIColor)? {
        return nil
    }
}

private extension ColorDynamicType {
    var darkColor: (UIColor) -> UIColor {
        return self.onDarkMode ?? {
            let components = $0.components

            if components.isGrayScale {
                return UIColor(white:{
                    return ((1 - components.red) * (1 - Self.darkSettings.grayScaleConstant)) + Self.darkSettings.grayScaleConstant
                }(), alpha: components.alpha)
            }

            return components.lighter(with: Self.darkSettings.rgbConstant).asColor
        }
    }
}

public extension TraitObject where T: UIColor {
    var asColor: UIColor {
        if #available(iOS 13.0, tvOS 13.0, *) {
            return .init(dynamicProvider: { trait in
                return self.onTrait(trait)
            })
        }

        return self.onTrait(.init())
    }
}
