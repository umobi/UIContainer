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

open class SpacerView: View {
    private weak var view: UIView!
    let margin: SpacerView.Margin

    public required init(_ view: UIView!, margin: Margin) {
        self.margin = margin
        super.init(frame: .zero)
        
        self.view = view
        AddSubview(self).addSubview(view)
        self.layout()
    }
    
    public convenience init(_ view: UIView!, top: CGFloat, bottom: CGFloat, leading: CGFloat, trailing: CGFloat) {
        self.init(view, margin: .init(top: top, bottom: bottom, leading: leading, trailing: trailing))
    }
    
    private func layout() {
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
