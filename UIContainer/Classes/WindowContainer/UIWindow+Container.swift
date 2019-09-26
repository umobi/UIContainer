//
//  UIWindow+Container.swift
//  UIContainer
//
//  Created by brennobemoura on 25/09/19.
//

import Foundation
import UIKit

public extension UIWindow {
    static func container<Provider: WindowProviderType>(_ providerType: Provider.Type) -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = WindowContainer<Provider>.init(rootViewController: providerType.launcher, window: window)
        window.backgroundColor = .white
        window.clipsToBounds = true
        return window
    }
}
