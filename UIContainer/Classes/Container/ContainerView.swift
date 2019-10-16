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

open class ContainerView<View: UIView & ContainerViewParent>: ContainerBox, UIContainer {
    
    public final weak var view: View!
    public weak var parent: ParentView!
    
    open override func removeFromSuperview() {
        self.removeContainer()
        super.removeFromSuperview()
    }
    
    open func spacer<T: UIView>(_ view: T) -> Spacer {
        return .init(view, spacing: 0)
    }
    
    open func containerDidLoad() {}
    
    public required init(in parentView: ParentView!, loadHandler: (() -> View?)? = nil) {
        super.init(frame: .zero)
        self.prepareContainer(inside: parentView, loadHandler: loadHandler)
        self.containerDidLoad()
    }
    
    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension UIContainer where Self: ContainerBox, View: UIView & ContainerViewParent {
    
    func prepareContainer(inside parentView: ParentView!, loadHandler: (() -> View?)? = nil) {
        self.prepare(parentView: parentView)
        
        guard let loader = loadHandler else {
            self.insertContainer(view: View())
            return
        }
        
        self.insertContainer(view: loader())
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
        self.addSubview(self.spacer(view))
    }
}
