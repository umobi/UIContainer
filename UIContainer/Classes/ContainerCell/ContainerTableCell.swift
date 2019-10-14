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

open class ContainerTableCell<View: UIViewController & ContainerCellDelegate>: UITableViewCell, UIContainerCell {
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
    
    required public init(in parentView: ParentView!, loadHandler: (() -> View?)? = nil) {
        super.init(style: .default, reuseIdentifier: nil)
        self.prepareContainer(inside: parentView, loadHandler: loadHandler)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
}
