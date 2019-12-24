//
//  SpacerMargin.swift
//  UIContainer
//
//  Created by brennobemoura on 19/09/19.
//

import Foundation
import UIKit

public extension SpacerView {
    class Margin {
        let top, bottom, leading, trailing: CGFloat
        
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
