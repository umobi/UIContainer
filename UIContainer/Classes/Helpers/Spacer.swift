//
//  Spacer.swift
//  mercadoon
//
//  Created by brennobemoura on 01/09/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

public class Spacer: UIView {
    private weak var view: UIView!
    let margin: Spacer.Margin
    
    internal init(_ view: UIView!, margin: Margin) {
        self.margin = margin
        super.init(frame: .zero)
        
        self.view = view
        self.addSubview(view)
        
        self.layout()
    }
    
    public convenience init(_ view: UIView!, top: CGFloat, bottom: CGFloat, leading: CGFloat, trailing: CGFloat) {
        self.init(view, margin: .init(top: top, bottom: bottom, leading: leading, trailing: trailing))
    }
    
    private func layout() {
        view.snp.makeConstraints {
            $0.top.equalTo(self.margin.top)
            $0.leading.equalTo(self.margin.leading)
            $0.trailing.equalTo(-self.margin.trailing)
            $0.bottom.equalTo(-self.margin.bottom)
        }
    }
    
    public convenience init(_ view: UIView!, vertical: CGFloat, horizontal: CGFloat) {
        self.init(view, margin: .init(vertical: vertical, horizontal: horizontal))
    }
    
    public convenience init(_ view: UIView!, spacing: CGFloat) {
        self.init(view, margin: .init(spacing: spacing))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("No aDecoder implemented")
    }
}

public extension Spacer {
    public class Margin {
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
