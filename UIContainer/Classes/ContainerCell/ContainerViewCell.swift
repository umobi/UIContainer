//
//  ContainerViewCell.swift
//  mercadoon
//
//  Created by brennobemoura on 01/09/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation
import UIKit

open class ContainerViewCell<View: UIView & ContainerViewParent & ContainerCellDelegate>: UITableViewCell, UIContainerCell {
    public weak var stackView: UIStackView!
    public weak var containerView: ContainerView<View>!
    public weak var parent: ParentView!
    
    open func spacer<T>(_ view: T) -> Spacer<T> {
        return .init(view, spacing: 0)
    }
    
    open func containerDidLoad() {}
}
