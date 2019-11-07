//
//  ContainerViewCell.swift
//  mercadoon
//
//  Created by brennobemoura on 01/09/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation
import UIKit

open class ContainerCollectionViewCell<View: UIView & ContainerViewParent & ContainerCellDelegate>: UICollectionViewCell, UIContainerCell {
    
    public weak var containerBox: ContainerBox!
    public weak var containerView: ContainerView<View>!
    public weak var parent: ParentView!
    
    open func spacer<T: UIView>(_ view: T) -> Spacer {
        return .init(view, spacing: 0)
    }
    
    open func containerDidLoad() {}
    
    required public init(in parentView: ParentView!, loadHandler: (() -> View?)? = nil) {
        super.init(frame: .zero)
        self.prepareContainer(inside: parentView, loadHandler: loadHandler)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
