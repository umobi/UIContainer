//
//  WindowProviderType.swift
//  Pods
//
//  Created by brennobemoura on 25/09/19.
//

import Foundation

public protocol WindowContainerType {
    var container: UIView! { get }
    
    static func launcher(in windowContainer: WindowContainer<Self>) -> UIView!
    
}
