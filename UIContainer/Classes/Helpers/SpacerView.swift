//
//  Spacer.swift
//  mercadoon
//
//  Created by brennobemoura on 01/09/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation
import UIKit
import EasyAnchor

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

        activate(
            view.anchor
                .top
                .constant(self.margin.top),

            view.anchor
                .bottom
                .constant(-self.margin.bottom),

            view.anchor
                .trailing
                .constant(-self.margin.trailing),

            view.anchor
                .leading
                .constant(self.margin.leading)
        )
    }
    public func addContent(_ view: UIView) {
        self.view = view
        AddSubview(self).addSubview(view)
        self.layout()
    }

    public func reloadContentLayout() {
        guard let view = self.view else {
            return
        }

        var pending: [ConstraintProducer] = []

        if view.anchor.find(.top) == nil {
            pending.append(
                view.anchor
                    .top
                    .constant(self.margin.top)
                )
        }

        if view.anchor.find(.bottom) == nil {
            pending.append(
                view.anchor
                    .bottom
                    .constant(-self.margin.bottom)
                )
        }

        if view.anchor.find(.leading) == nil {
            pending.append(
                view.anchor
                    .leading
                    .constant(self.margin.leading)
                )
        }

        if view.anchor.find(.trailing) == nil {
            pending.append(
                view.anchor
                    .trailing
                    .constant(-self.margin.trailing)
                )
        }

        pending.forEach {
            activate($0)
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
