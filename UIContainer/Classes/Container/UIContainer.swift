//
//  UIContainer.swift
//  mercadoon
//
//  Created by brennobemoura on 06/09/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation
import UIKit

public protocol UIContainer: class {
    typealias ParentView = UIViewController
    associatedtype View: AnyObject
    
    var view: View! { get set }
    var parent: ParentView! { get set }
    
    func prepareContainer(inside parentView: ParentView!)
    
    func removeContainer()
    
    func insertContainer(view: View!)
    
    static func load(in parentView: ParentView!) -> Self
    
    func prepare(parentView: ParentView!)
    
    func spacer<T: UIView>(_ view: T) -> Spacer<T>
    
    func containerDidLoad()
    
    init()
}

public extension UIContainer {
    func prepare(parentView: ParentView!) {
        self.parent = parentView
    }
    
    func spacer<T>(_ view: T) -> Spacer<T> where T : UIView {
        return .init(view, spacing: 0)
    }
}