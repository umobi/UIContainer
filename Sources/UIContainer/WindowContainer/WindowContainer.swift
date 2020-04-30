//
// Copyright (c) 2019-Present Umobi - https://github.com/umobi
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation
import UIKit
import ConstraintBuilder

extension NotificationCenter {
    fileprivate func traitDidChange(_ traitCollection: UITraitCollection) {
        self.post(.init(name: .init("UIViewController.traitDidChange"), object: nil, userInfo: ["traitCollection": traitCollection]))
    }

    func onTraitChange(_ handler: @escaping (UITraitCollection) -> Void) {
        self.addObserver(forName: .init("UIViewController.traitDidChange"), object: nil, queue: nil, using: {
            guard let trait = $0.userInfo?["traitCollection"] as? UITraitCollection else {
                return
            }

            handler(trait)
        })
    }
}

public class WindowContainer<Provider: WindowContainerType>: UIViewController, StatusBarAppearanceManager {
    
    private weak var stackView: UIStackView!
    private weak var container: UIView!
    
    weak var window: UIWindow!
    
    public private(set) var baseType: Provider?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareStack()
    }

    #if os(iOS)
    public var statusBarStyle: UIStatusBarStyle? = nil {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.statusBarStyle ?? UIApplication.shared.statusBarStyle
    }
    #endif
    
    public init(_ window: UIWindow) {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
        self.window = window
        
        let container: UIView! = Provider.launcher(in: self)
        if !(container is ContainerType) {
            fatalError("WindowContainer only accepts classes derivated from ContainerRepresentable protocol")
        }

        AddSubview(self.stackView).addArrangedSubview(container)
        self.container = container
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        NotificationCenter.default.traitDidChange(self.traitCollection)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func changeContainer(_ containerView: UIView!, animated: Bool, completion handler: (() -> Void)? = nil) {
        if !(containerView is ContainerType) {
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

        Constraintable.activate(
            stackView.cbuild
                .edges
        )
    }
}
