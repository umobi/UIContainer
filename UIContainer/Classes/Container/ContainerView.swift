//
//  ContainerView.swift
//  mercadoon
//
//  Created by brennobemoura on 01/09/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation
import UIKit

public  protocol ContainerViewParent {
    var parent: UIViewController! { get set }
}

open class ContainerView<View: UIView & ContainerViewParent>: UIStackView, UIContainer {
    
    public final weak var view: View!
    public weak var parent: ParentView!
    
    open override func removeFromSuperview() {
        super.removeFromSuperview()
        self.removeContainer()
    }
    
    open func spacer<T: UIView>(_ view: T) -> Spacer {
        return .init(view, spacing: 0)
    }
    
    open func containerDidLoad() {}
}

public extension UIContainer where Self: UIStackView, View: UIView & ContainerViewParent {
    
    func prepareContainer(inside parentView: ParentView!) {
        self.prepare(parentView: parentView)
        self.insertContainer(view: View())
    }
    
    func removeContainer() {
        guard let view = view else {
            return
        }
        
        let spacer = view.superview
        view.removeFromSuperview()
        spacer?.removeFromSuperview()
    }
    
    func insertContainer(view: View!) {
        self.removeContainer()
        
        self.view = view
        self.view.parent = self.parent
        self.addArrangedSubview(self.spacer(view))
    }
    
    static func load(in parent: UIViewController!) -> Self {
        let container = self.init()
        container.prepareContainer(inside: parent)
        container.containerDidLoad()
        return container
    }
}
