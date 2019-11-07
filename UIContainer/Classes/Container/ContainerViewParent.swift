//
//  ContainerViewParent.swift
//  UIContainer
//
//  Created by brennobemoura on 07/11/19.
//

import Foundation
import UIKit

public protocol ContainerViewParent {
    var parent: UIViewController! { get set }
}

extension UIViewController: ContainerViewParent {
    public var parent: UIViewController! {
        get {
            return self.parent!
        }
        set {
            self.parent = self.parent as UIViewController?
        }
    }
}
