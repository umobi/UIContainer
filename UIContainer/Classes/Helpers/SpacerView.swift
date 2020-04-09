//
//  Spacer.swift
//  mercadoon
//
//  Created by brennobemoura on 01/09/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation
import UIKit
import ConstraintBuilder

open class SpacerView: View, Content {
    private weak var view: UIView?
    let margin: SpacerView.Margin

    public required init(margin: Margin) {
        self.margin = margin
        super.init(frame: .zero)
    }

    public required init(_ view: UIView!, margin: Margin) {
        self.margin = margin
        super.init(frame: .zero)
        
        self.addContent(view)
    }
    
    public convenience init(_ view: UIView!, top: CGFloat, bottom: CGFloat, leading: CGFloat, trailing: CGFloat) {
        self.init(view, margin: .init(top: top, bottom: bottom, leading: leading, trailing: trailing))
    }
    
    private func layout() {
        guard let view = self.view else {
            return
        }

        Constraintable.update(
            view.cbuild
                .top
                .equalTo(self)
                .update()
                .constant(self.margin.top),

            view.cbuild
                .bottom
                .equalTo(self)
                .update()
                .constant(self.margin.bottom),

            view.cbuild
                .trailing
                .equalTo(self)
                .update()
                .constant(self.margin.trailing),

            view.cbuild
                .leading
                .equalTo(self)
                .update()
                .constant(self.margin.leading)
        )
    }

    public func addContent(_ view: UIView) {
        self.view = view
        AddSubview(self).addSubview(view)
        self.layout()
    }

    public func reloadContentLayout() {
        guard self.view != nil else {
            return
        }

        self.layout()
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
