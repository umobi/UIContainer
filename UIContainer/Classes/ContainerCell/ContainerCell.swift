//
//  ContainerCell.swift
//  mercadoon
//
//  Created by brennobemoura on 02/09/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

open class ContainerCell<View: UIViewController & ContainerCellDelegate>: UITableViewCell, UIContainerCell {
    public weak var stackView: UIStackView!
    public weak var containerView: Container<View>!
    public weak var parent: ParentView!
    
    private func createSV() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        self.contentView.addSubview(stackView)
        self.stackView = stackView
        stackView.snp.makeConstraints { $0.edges.equalTo(0) }
    }
    
    open func spacer<T: UIView>(_ view: T) -> Spacer {
        return .init(view, spacing: 0)
    }
    
    open func containerDidLoad() {}
}
