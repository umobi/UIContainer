//
//  WindowProviderType.swift
//  Pods
//
//  Created by brennobemoura on 25/09/19.
//

import Foundation

public protocol WindowProviderType {
    var viewController: UIViewController! { get }
    
    static var launcher: UIViewController! { get }
}
