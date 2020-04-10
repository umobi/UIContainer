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
