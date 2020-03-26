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

    enum Relation: CaseIterable {
        case top
        case bottom
        case leading
        case trailing

        func anchor(_ view: UIView) -> Anchor {
            switch self {
            case .top:
                return view.anchor.top
            case .bottom:
                return view.anchor.bottom
            case .leading:
                return view.anchor.leading
            case .trailing:
                return view.anchor.trailing
            }
        }

        func constant(_ margin: Margin) -> CGFloat {
            switch self {
            case .top:
                return margin.top
            case .leading:
                return margin.leading
            case .trailing:
                return -margin.trailing
            case .bottom:
                return -margin.bottom
            }
        }
    }

    func update(_ relation: Relation) {
        guard let view = self.view else {
            return
        }

        let constraints = relation.anchor(view).find()

        if constraints.isEmpty {
            activate(
                relation.anchor(view)
                    .constant(relation.constant(self.margin))
            )
            return
        }

        constraints.forEach {
            $0.constant = relation.constant(self.margin)
        }
    }

    public func reloadContentLayout() {
        guard let view = self.view else {
            return
        }

        Relation.allCases.forEach {
            self.update($0)
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
