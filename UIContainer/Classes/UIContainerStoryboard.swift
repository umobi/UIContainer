//
//  UIContainerStoryboard.swift
//  mercadoon
//
//  Created by brennobemoura on 06/09/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

public protocol UIContainerStoryboard: View, ContainerRepresentable where View == Container.View {
    associatedtype Container: ContainerRepresentable
    var containerView: Container! { get set }
    
    func addContainer(_ container: Container)
    
    var margin: SpacerView.Margin { get set }
}

public extension UIContainerStoryboard {
    weak var view: Container.View! {
        get {
            return self.containerView.view
        }
        
        set {
            self.containerView.view = newValue
        }
    }
    
    weak var parent: ParentView! {
        get {
            return self.containerView.parent
        }
        
        set {
            fatalError("Setting parent for UIContainerStoryboard should never happen")
        }
    }
    
    func removeContainer() {
        fatalError("Don't try to remove ContainerStoryboard")
    }
    
    func insertContainer(view: View!) {
        fatalError("Don't try to insert in ContainerCell")
    }
    
    func prepareContainer(inside parentView: ParentView!, loadHandler: (() -> View?)? = nil) {
        if loadHandler != nil {
            fatalError("ContainerStoryboard should not be prepared with loadHandler")
        }
        
        if self.containerView != nil {
            return
        }
        
        let containerView = Container(in: parentView, loadHandler: loadHandler)
        self.containerView = containerView
        self.addContainer(containerView)
        
        self.containerDidLoad()
    }
    
    func prepareContainer(inside parentView: ParentView!, margin: SpacerView.Margin) {
        self.margin = margin
        self.prepareContainer(inside: parentView)
    }
    
    init(in parentView: ParentView!, loadHandler: (() -> View?)?) {
        fatalError("ContainerStoryboard should not be instanciated by code")
    }
}

public extension UIContainerStoryboard where Container: UIView {
    func addContainer(_ container: Container) {
        let spacer = self.spacer(container)
        AddSubview(self).insertSubview(spacer, at: 0)
        spacer.snp.makeConstraints { $0.edges.equalTo(0) }
    }
    
    func spacer<T>(_ view: T) -> SpacerView where T : UIView {
        return .init(view, margin: self.margin)
    }
}
