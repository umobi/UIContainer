//
//  UIWindow+Container.swift
//  UIContainer
//
//  Created by brennobemoura on 25/09/19.
//

import Foundation
import UIKit

public extension UIWindow {
    static func container<Provider: WindowContainerType>(_ providerType: Provider.Type) -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = WindowContainer<Provider>(window)
        window.backgroundColor = .white
        window.clipsToBounds = true
        return window
    }
}

public protocol ViewSharedContext {
    static var __shared: Self? { get set }
    static var shared: Self { get }
    
    static func loadView() -> Self
}

public extension ViewSharedContext {
    static var shared: Self {
        let shared = self.__shared ?? self.loadView()
        self.__shared = shared
        return shared
    }
}
