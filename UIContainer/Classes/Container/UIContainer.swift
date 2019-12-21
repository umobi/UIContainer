//
//  UIContainer.swift
//  mercadoon
//
//  Created by brennobemoura on 06/09/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation
import UIKit

public protocol ContainerRepresentable: class {
    typealias ParentView = UIViewController
    associatedtype View: AnyObject
    
    var view: View! { get set }
    var parent: ParentView! { get set }
    
    func prepareContainer(inside parentView: ParentView!, loadHandler: (() -> View?)?)
    
    func removeContainer()
    
    func insertContainer(view: View!)
    
    func prepare(parentView: ParentView!)
    
    func spacer<T: UIView>(_ view: T) -> Spacer
    
    func containerDidLoad()
    
    init(in parentView: ParentView!, loadHandler: (() -> View?)?)
}

public extension ContainerRepresentable {
    func prepare(parentView: ParentView!) {
        self.parent = parentView
    }
    
    func spacer<T: UIView>(_ view: T) -> Spacer {
        return .init(view, spacing: 0)
    }
}
