//
//  DynamicColor.swift
//  mercadoon
//
//  Created by brennobemoura on 31/10/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
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
    static func dynamic(onLight whiteColor: UIColor, onDark darkColor: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else {
            return whiteColor
        }

        return UIColor { (traits) -> UIColor in
            return traits.userInterfaceStyle == .dark ?
                darkColor :
                whiteColor
        }
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
        if #available(iOS 13.0, *) {
            return .init(dynamicProvider: { trait in
                return self.onTrait(trait)
            })
        } else {
            return self.onTrait(.init())
        }
    }
}
