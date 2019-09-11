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

public class Spacer<T: UIView>: UIView {
    private weak var view: T!
    
    public init(_ view: T!, top: CGFloat, bottom: CGFloat, leading: CGFloat, trailing: CGFloat) {
        super.init(frame: .zero)
        
        self.view = view
        self.addSubview(view)
        
        view.snp.makeConstraints {
            $0.top.equalTo(top)
            $0.leading.equalTo(leading)
            $0.trailing.equalTo(-trailing)
            $0.bottom.equalTo(-bottom)
        }
    }
    
    public convenience init(_ view: T!, vertical: CGFloat, horizontal: CGFloat) {
        self.init(view, top: vertical, bottom: vertical, leading: horizontal, trailing: horizontal)
    }
    
    public convenience init(_ view: T!, spacing: CGFloat) {
        self.init(view, top: spacing, bottom: spacing, leading: spacing, trailing: spacing)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("No aDecoder implemented")
    }
}
