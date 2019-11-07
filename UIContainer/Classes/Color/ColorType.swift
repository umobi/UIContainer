//
//  ColorKey.swift
//  mercadoon
//
//  Created by brennobemoura on 31/10/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation
import UIKit

public protocol ColorType: OptionSet where RawValue == Int {
    static var white: Self { get }

    var color: UIColor { get }

    init(white: CGFloat, alpha: CGFloat)
}

public extension ColorType {

    init(white: CGFloat, alpha: CGFloat) {
        self.init(rawValue: Self.white.color.components.darker(with: 1-white).alpha(constant: alpha).hash)
    }

    init(hex: String) {
        self.init(rawValue: UIColor(hex: hex)!.components.hash)
    }

    var color: UIColor {
        return ColorComponents.init(hash: self.rawValue).asColor
    }

    func darker(with constant: CGFloat) -> Self {
        return .init(rawValue: self.color.components.darker(with: constant).hash)
    }

    func alpha(constant alpha: CGFloat) -> Self {
        return .init(rawValue: self.color.components.alpha(constant: alpha).hash)
    }

    static var white: Self {
        return self.init(hex: UIColor.white.components.hex)
    }
}
