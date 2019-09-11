//
//  Container.swift
//  mercadoon
//
//  Created by brennobemoura on 02/09/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation
import UIKit

open class Container<View: UIViewController>: UIStackView, UIContainer {
    public weak var view: View!
    public weak var parent: ParentView!
    
    open override func removeFromSuperview() {
        super.removeFromSuperview()
        self.removeContainer()
    }
    
    open func containerDidLoad() {}
}

public extension UIContainer where Self: UIStackView, View: UIViewController {
    func prepareContainer(inside parentView: ParentView!) {
        self.prepare(parentView: parentView)
        self.insertContainer(view: View.fromNib())
    }
    
    func removeContainer() {
        guard let view = view else {
            return
        }
        
        let spacer = view.view.superview
        view.willMove(toParent: nil)
        view.view.removeFromSuperview()
        spacer?.removeFromSuperview()
        view.removeFromParent()
    }
    
    func insertContainer(view: View!) {
        self.removeContainer()
        
        self.view = view
        parent.addChild(view)
        self.addArrangedSubview(self.spacer(view.view))
        view.didMove(toParent: self.parent)
    }
    
    static func load(in parentView: ParentView!) -> Self {
        let container = self.init()
        container.prepareContainer(inside: parentView)
        container.containerDidLoad()
        return container
    }
}
