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

@available(*, deprecated, message: "moved to UICreator")
public extension SpacerView {
    class Margin {
        public let top, bottom, leading, trailing: CGFloat
        
        public required init(top: CGFloat, bottom: CGFloat, leading: CGFloat, trailing: CGFloat) {
            self.top = top
            self.bottom = bottom
            self.leading = leading
            self.trailing = trailing
        }
        
        public convenience init(vertical: CGFloat, horizontal: CGFloat) {
            self.init(top: vertical, bottom: vertical, leading: horizontal, trailing: horizontal)
        }
        
        public convenience init(spacing: CGFloat) {
            self.init(top: spacing, bottom: spacing, leading: spacing, trailing: spacing)
        }
        
        public func update(top: CGFloat) -> Self {
            return .init(
                top: top,
                bottom: bottom,
                leading: leading,
                trailing: trailing
            )
        }
        
        public func update(bottom: CGFloat) -> Self {
            return .init(
                top: top,
                bottom: bottom,
                leading: leading,
                trailing: trailing
            )
        }
        
        public func update(leading: CGFloat) -> Self {
            return .init(
                top: top,
                bottom: bottom,
                leading: leading,
                trailing: trailing
            )
        }
        
        public func update(trailing: CGFloat) -> Self {
            return .init(
                top: top,
                bottom: bottom,
                leading: leading,
                trailing: trailing
            )
        }
        
        public static var zero: Margin {
            return .init(top: 0, bottom: 0, leading: 0, trailing: 0)
        }
    }
}
