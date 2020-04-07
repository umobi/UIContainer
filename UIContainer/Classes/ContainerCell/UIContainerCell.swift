//
//  File.swift
//  mercadoon
//
//  Created by brennobemoura on 06/09/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation
import UIKit
import ConstraintBuilder

public protocol ContainerCellRepresentable: ContainerRepresentable where ContainerCell.View == View {
    associatedtype ContainerCell: ContainerRepresentable
    var containerView: ContainerCell! { get set }
    
    func addCell(_ containerCell: ContainerCell)
    
    //func containerDidLoad()
    func spacer<T: UIView>(_ view: T) -> SpacerView
}

public extension ContainerCellRepresentable {
    weak var view: ContainerCell.View! {
        get {
            return self.containerView.view
        }
        
        set {
            self.containerView.view = newValue
        }
    }
    
    func removeContainer() {
        fatalError("Don't try to remove ContainerCell")
    }
    
    func insertContainer(view: View!) {
        fatalError("Don't try to insert in ContainerCell")
    }
    
    weak var parent: ParentView! {
        get {
            return self.containerView.parent
        }
        
        set {
            fatalError("Setting parent for UIContainerCell should never happen")
        }
    }
}

public extension ContainerCellRepresentable where Self: UICollectionViewCell, ContainerCell: UIView {
    func addCell(_ containerCell: ContainerCell) {
        let spacer = self.spacer(containerCell)
        AddSubview(self.contentView).addSubview(spacer)

        Constraintable.activate(
            spacer.cbuild
                .edges
        )
    }
}

public extension ContainerCellRepresentable where Self: UITableViewCell, ContainerCell: UIView {
    func addCell(_ containerCell: ContainerCell) {
        let spacer = self.spacer(containerCell)
        AddSubview(self.contentView).addSubview(spacer)

        Constraintable.activate(
            spacer.cbuild
                .edges
        )
    }
}

public extension ContainerCellRepresentable where View: ContainerCellDelegate {
    func prepareContainer(inside parentView: ParentView!, loadHandler: (() -> View?)? = nil) {
        if self.containerView != nil {
            return
        }
        
        let containerView = ContainerCell(in: parentView, loadHandler: loadHandler)
        containerView.view.cellDelegate = parentView as? ContainerCell.View.Delegate
        
        self.containerView = containerView
        self.addCell(containerView)
        
        self.containerDidLoad()
    }
}
