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

public class Spacer: View {
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
