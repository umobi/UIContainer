//
//  ContainerCell.swift
//  mercadoon
//
//  Created by brennobemoura on 02/09/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation
import UIKit

open class ContainerCollectionCell<View: UIViewController & ContainerCellDelegate>: UICollectionViewCell, ContainerCellRepresentable {
    public weak var containerView: Container<View>!
    public weak var parent: ParentView!
    
    open func spacer<T: UIView>(_ view: T) -> SpacerView {
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
}
