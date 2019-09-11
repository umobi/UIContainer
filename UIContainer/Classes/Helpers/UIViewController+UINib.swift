//
//  UIViewController+UINib.swift
//  mercadoon
//
//  Created by brennobemoura on 06/09/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {
    class func fromNib(_ nibName: String? = nil) -> Self {
        let identifier = nibName ?? "\(self)"
        return fromNib(nibName: identifier)
    }
    
    class func fromNib<T: UIViewController>(nibName: String) -> T {
        return T(nibName: nibName, bundle: nil)
    }
}
