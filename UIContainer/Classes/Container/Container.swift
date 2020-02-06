//
//  Container.swift
//  mercadoon
//
//  Created by brennobemoura on 02/09/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation
import UIKit

open class Container<View: UIViewController>: ContainerBox, ContainerRepresentable {
    
    public weak var view: View!
    public weak var parent: ParentView!
    
    open override func removeFromSuperview() {
        super.removeFromSuperview()
        self.removeContainer()
    }
    
    open func containerDidLoad() {}
    
    public required init(in parentView: ParentView!, loadHandler: (() -> View?)? = nil) {
        super.init(frame: .zero)
        self.prepareContainer(inside: parentView, loadHandler: loadHandler)
        self.containerDidLoad()
    }
    
    public required init() {
        super.init(frame: .zero)
    }
    
    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension ContainerRepresentable where Self: ContainerBox, View: UIViewController {
    func prepareContainer(inside parentView: ParentView!, loadHandler: (() -> View?)? = nil) {
        self.prepare(parentView: parentView)
        
        guard let loader = loadHandler else {
            self.insertContainer(view: View.fromNib())
            return
        }
        
        self.insertContainer(view: loader())
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
        parent?.addChild(view)
        AddSubview(self).addSubview(self.spacer(view.view))
        view.didMove(toParent: self.parent)
    }
}
