//
//  WindowContainer.swift
//  Pods-UIContainer_Tests
//
//  Created by brennobemoura on 25/09/19.
//

import Foundation
import UIKit

public class WindowContainer<Provider: WindowContainerType>: UIViewController {
    
    private weak var stackView: UIStackView!
    private weak var container: UIView!
    
    weak var window: UIWindow!
    
    public private(set) var baseType: Provider?

    #if os(iOS)
    public var statusBarStyle: UIStatusBarStyle? = nil {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    #endif
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareStack()

        #if DEBUG
        if Provider.showDebugView {
            self.prepareDebugView()
        }
        #endif
    }

    #if os(iOS)
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.statusBarStyle ?? UIApplication.shared.statusBarStyle
    }
    #endif
    
    public init(_ window: UIWindow) {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
        self.window = window
        
        let container: UIView! = Provider.launcher(in: self)
        if !(container is ContainerRepresentable) {
            fatalError("WindowContainer only accepts classes derivated from ContainerRepresentable protocol")
        }

        AddSubview(self.stackView).addArrangedSubview(container)
        self.container = container
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func changeContainer(_ containerView: UIView!, animated: Bool, completion handler: (() -> Void)? = nil) {
        if !(containerView is ContainerRepresentable) {
            fatalError("WindowContainer only accepts classes derivated from ContainerRepresentable protocol")
        }

        AddSubview(self.stackView).addArrangedSubview(containerView)
        
        let perform: () -> Void = {
            self.container?.removeFromSuperview()
            self.dismiss(animated: false, completion: nil)
        }
        
        let commitChanges: () -> Void = {
            // Commit Changes
            self.container = containerView
            #if os(iOS)
            self.setNeedsStatusBarAppearanceUpdate()
            #endif
            handler?()
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
        if let container = self.container as? Container {
            guard let root = container.view else {
                return
            }

            sequence(first: root, next: { $0.presentedViewController })
                .reversed()
                .last?
                .present(viewControllerToPresent, animated: flag, completion: completion)
            return
        }

        let view = sequence(first: self, next: { $0.presentedViewController })
            .reversed()
            .last

        guard view != self else {
            super.present(viewControllerToPresent, animated: flag, completion: completion)
            return
        }

        view?.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    public func transition(toView viewController: UIViewController!, as providerType: Provider, completion handler: (() -> Void)? = nil) {
        self.baseType = providerType
        self.changeContainer(Container(in: self) { viewController }, animated: true, completion: handler)
    }
    
    public func transition(to providerType: Provider, completion handler: (() -> Void)? = nil) {
        self.baseType = providerType
        self.changeContainer(providerType.container, animated: true, completion: handler)
    }
}

extension WindowContainer {
    func prepareStack() {
        let stackView = UIStackView()
        AddSubview(self.view).addSubview(stackView)
        self.stackView = stackView
        
        self.stackView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(0)
        }
    }

    func prepareDebugView() {
        let debugView = DebugView()
        AddSubview(self.view).addSubview(debugView)
        debugView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
    }
}
