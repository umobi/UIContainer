//
//  File.swift
//  mercadoon
//
//  Created by brennobemoura on 06/09/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation
import UIKit

public protocol UIContainerCell: UIContainer where ContainerCell.View == View {
    associatedtype ContainerCell: UIContainer
    var containerView: ContainerCell! { get set }
    
    func addCell(_ containerCell: ContainerCell)
    
    //func containerDidLoad()
    func spacer<T: UIView>(_ view: T) -> Spacer
}

public extension UIContainerCell {
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

public extension UIContainerCell where Self: UICollectionViewCell, ContainerCell: UIView {
    func addCell(_ containerCell: ContainerCell) {
        let spacer = self.spacer(containerCell)
        self.contentView.addSubview(spacer)
        spacer.snp.makeConstraints { $0.edges.equalTo(0) }
    }
}

public extension UIContainerCell where Self: UITableViewCell, ContainerCell: UIView {
    func addCell(_ containerCell: ContainerCell) {
        let spacer = self.spacer(containerCell)
        self.contentView.addSubview(spacer)
        spacer.snp.makeConstraints { $0.edges.equalTo(0) }
    }
}

public extension UIContainerCell where View: ContainerCellDelegate {
    func prepareContainer(inside parentView: ParentView!, loadHandler: (() -> View?)? = nil) {
        if self.containerView != nil {
            return
        }
        
        let delegate: View.Delegate? = {
            if View.Delegate.self == EmptyCellDelegate.self {
                return nil
            }
            
            guard let delegate = parentView as? ContainerCell.View.Delegate else {
                fatalError("ParentViewController should extend protocol \(String(describing: ContainerCell.View.Delegate.self))")
            }
            
            return delegate
        }()
        
        let containerView = ContainerCell(in: parentView, loadHandler: loadHandler)
        containerView.view.cellDelegate = delegate
        
        self.containerView = containerView
        self.addCell(containerView)
        
        self.containerDidLoad()
    }
}
