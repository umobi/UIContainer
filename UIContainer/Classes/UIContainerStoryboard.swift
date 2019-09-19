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

public protocol UIContainerStoryboard: View, UIContainer where View == Container.View {
    associatedtype Container: UIContainer
    var containerView: Container! { get set }
    
    func addContainer(_ container: Container)
    
    var margin: Spacer.Margin { get set }
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
    
    static func load(in parentView: ParentView!) -> Self {
        fatalError("ContainerStoryboard should not be instanciated by code")
    }
    
    func prepareContainer(inside parentView: ParentView!) {
        if self.containerView != nil {
            return
        }
        
        let containerView = Container.load(in: parentView)
        self.containerView = containerView
        self.addContainer(containerView)
        
        self.containerDidLoad()
    }
    
    func prepareContainer(inside parentView: ParentView!, margin: Spacer.Margin) {
        self.margin = margin
        self.prepareContainer(inside: parentView)
    }
}

public extension UIContainerStoryboard where Container: UIView {
    func addContainer(_ container: Container) {
        let spacer = self.spacer(container)
        self.insertSubview(spacer, at: 0)
        spacer.snp.makeConstraints { $0.edges.equalTo(0) }
    }
    
    func spacer<T>(_ view: T) -> Spacer where T : UIView {
        return .init(view, margin: self.margin)
    }
}
