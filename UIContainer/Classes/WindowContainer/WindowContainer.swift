//
//  WindowContainer.swift
//  Pods-UIContainer_Tests
//
//  Created by brennobemoura on 25/09/19.
//

import Foundation
import UIKit

public class WindowContainer<Provider: WindowProviderType>: UIViewController {
    private weak var container: Container<UIViewController>!
    public weak var rootViewController: UIViewController! {
        return self.container.view
    }
    
    weak var window: UIWindow!
    
    public private(set) var baseType: Provider?
    public var statusBarStyle: UIStatusBarStyle? = nil {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return self.statusBarStyle ?? UIApplication.shared.statusBarStyle
    }
    
    public init(rootViewController: UIViewController, window: UIWindow) {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
        self.window = window
        
        let container =  Container<UIViewController>(in: self, loadHandler: { rootViewController })
        self.view.addSubview(container)
        container.snp.makeConstraints { $0.edges.equalTo(0) }
        self.container = container
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    public func changeView(_ viewController: UIViewController?, animated: Bool, completion handler: (() -> Void)? = nil) {
        guard let viewController = viewController else {
            return
        }
        
        // Add and remove Views
        // Will be remove
        
        let perform: () -> Void = {
            self.container.insertContainer(view: viewController)
            self.dismiss(animated: false, completion: nil)
        }
        
        let commitChanges: () -> Void = {
            // Commit Changes
            self.setNeedsStatusBarAppearanceUpdate()
        }
        
        if animated {
            UIView.transition(with: window!, duration: 0.4, options: .transitionCrossDissolve, animations: {
                perform()
            }) { _ in
                commitChanges()
            }
        } else {
            perform()
            commitChanges()
        }
    }
    
    override public func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        guard let root = self.rootViewController else {
            return
        }
        
        if root.presentedViewController != nil {
            print("[WindowContainer] WindowContainer will dismiss any present actions")
            return
        }
        
        root.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    public func transition(toView viewController: UIViewController, as providerType: Provider, completion handler: (() -> Void)? = nil) {
        self.baseType = providerType
        self.changeView(viewController, animated: true, completion: handler)
    }
    
    public func transition(to providerType: Provider, completion handler: (() -> Void)? = nil) {
        self.transition(toView: providerType.viewController, as: providerType, completion: handler)
    }
}
