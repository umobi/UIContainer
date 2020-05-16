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
import ConstraintBuilder

#if os(macOS)
import AppKit

public extension NSWindow {
    fileprivate enum CTViewPresent {
        case sheet
        case modal
        case animator(NSViewControllerPresentationAnimator)
        case popover(NSRect, NSView, NSRectEdge, NSPopover.Behavior)
    }

    class WindowContainer<Provider: WindowContainerType>: CBViewController, StatusBarAppearanceManager {

        private weak var stackView: CBStackView!
        private weak var container: CBView!

        public private(set) var baseType: Provider?

        public init() {
            super.init(nibName: nil, bundle: nil)
        }

        public override func loadView() {
            let stackView = self.loadStack()

            let container: CBView! = Provider.launcher(in: self)
            if !(container is ContainerType) {
                fatalError("WindowContainer only accepts classes derivated from ContainerRepresentable protocol")
            }

            CBView.CBSubview(self.stackView).addArrangedSubview(container)
            self.container = container
            self.view = stackView
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError()
        }

        private func changeContainer(_ containerView: CBView!, animated: Bool, completion handler: (() -> Void)? = nil) {
            if !(containerView is ContainerType) {
                fatalError("WindowContainer only accepts classes derivated from ContainerRepresentable protocol")
            }

            CBView.CBSubview(self.stackView).addArrangedSubview(containerView)

            let perform: () -> Void = {
                self.container?.removeFromSuperview()
                self.presentedViewControllers?.forEach {
                    self.dismiss($0)
                }
            }

            let commitChanges: () -> Void = {
                // Commit Changes
                self.container = containerView
                handler?()
            }

            if animated {
                CATransaction.begin()
                CATransaction.setCompletionBlock(commitChanges)
                CATransaction.setAnimationDuration(0.4)
                CATransaction.setAnimationTimingFunction(.init(name: .easeInEaseOut))
                perform()
                CATransaction.commit()
            } else {
                perform()
                commitChanges()
            }
        }

        private func present(_ viewController: NSViewController, in hostController: NSViewController, type: Present) {
            switch type {
            case .sheet:
                if hostController === self {
                    super.presentAsSheet(viewController)
                    return
                }

                hostController.presentAsSheet(viewController)
            case .modal:
                if hostController === self {
                    super.presentAsModalWindow(viewController)
                    return
                }

                hostController.presentAsModalWindow(viewController)
            case .animator(let animator):
                if hostController === self {
                    super.present(viewController, animator: animator)
                    return
                }

                hostController.present(viewController, animator: animator)
            case .popover(let positioningRect, let positioningView, let preferredEdge, let behavior):
                if hostController === self {
                    super.present(viewController, asPopoverRelativeTo: positioningRect, of: positioningView, preferredEdge: preferredEdge, behavior: behavior)
                    return
                }

                hostController.present(viewController, asPopoverRelativeTo: positioningRect, of: positioningView, preferredEdge: preferredEdge, behavior: behavior)
            }
        }

        private func present(_ viewController: NSViewController, type: CTViewPresent) {
            if let container = self.container as? Container {
                guard let root = container.view else {
                    return
                }

                guard
                    let hostController = root.sequenceOfPresentedViewControllers
                    .reversed()
                    .last?
                    .last
                    else {
                        return
                    }

                self.present(viewController, in: hostController, type: type)
                return
            }

            let view = self.sequenceOfPresentedViewControllers
                .reversed()
                .last?
                .last

            guard view !== self else {
                self.present(viewController, in: self, type: type)
                return
            }

            self.present(viewController, in: view!, type: type)
        }

        override public func presentAsModalWindow(_ viewController: NSViewController) {
            self.present(viewController, type: .modal)
        }

        override public func presentAsSheet(_ viewController: NSViewController) {
            self.present(viewController, type: .sheet)
        }

        override public func present(_ viewController: NSViewController, animator: NSViewControllerPresentationAnimator) {
            self.present(viewController, type: .animator(animator))
        }

        override public func present(_ viewController: NSViewController, asPopoverRelativeTo positioningRect: NSRect, of positioningView: NSView, preferredEdge: NSRectEdge, behavior: NSPopover.Behavior) {
            self.present(viewController, type: .popover(positioningRect, positioningView, preferredEdge, behavior))
        }

        public func transition(
            toView viewController: CBViewController!,
            as providerType: Provider,
            completion handler: (() -> Void)? = nil
        ) {
            self.baseType = providerType
            self.changeContainer(Container(in: self) { viewController }, animated: true, completion: handler)
        }

        public func transition(to providerType: Provider, completion handler: (() -> Void)? = nil) {
            self.baseType = providerType
            self.changeContainer(providerType.container, animated: true, completion: handler)
        }
    }
}

extension NSViewController {
    var sequenceOfPresentedViewControllers: UnfoldSequence<[NSViewController], ([NSViewController]?, Bool)> {
        sequence(first: [self], next: {
            let presentedViewControllers = $0.reduce([]) { $0 + ($1.presentedViewControllers ?? []) }
            if presentedViewControllers.isEmpty {
                return nil
            }

            return presentedViewControllers
        })
    }
}

#else
import UIKit

public extension UIWindow {
    class WindowContainer<Provider: WindowContainerType>: CBViewController, StatusBarAppearanceManager {

        private weak var stackView: CBStackView!
        private weak var container: CBView!

        public private(set) var baseType: Provider?

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

        public init() {
            super.init(nibName: nil, bundle: nil)
        }

        public override func loadView() {
            let stackView = self.loadStack()

            let container: CBView! = Provider.launcher(in: self)
            if !(container is ContainerType) {
                fatalError("WindowContainer only accepts classes derivated from ContainerRepresentable protocol")
            }

            CBView.CBSubview(self.stackView).addArrangedSubview(container)
            self.container = container
            self.view = stackView
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError()
        }

        private func changeContainer(
            _ containerView: CBView!,
            animated: Bool,
            completion handler: (() -> Void)? = nil) {
            if !(containerView is ContainerType) {
                fatalError("WindowContainer only accepts classes derivated from ContainerRepresentable protocol")
            }

            CBView.CBSubview(self.stackView).addArrangedSubview(containerView)

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
                CBView.transition(
                    with: self.view.window!,
                    duration: 0.4,
                    options: .transitionCrossDissolve,
                    animations: {
                        perform()
                    },
                    completion: { _ in
                        commitChanges()
                    })
            } else {
                perform()
                commitChanges()
            }
        }

        override public func present(
            _ viewControllerToPresent: CBViewController,
            animated flag: Bool,
            completion: (() -> Void)? = nil) {
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

        public func transition(
            toView viewController: CBViewController!,
            as providerType: Provider,
            completion handler: (() -> Void)? = nil) {
            self.baseType = providerType
            self.changeContainer(Container(in: self) { viewController }, animated: true, completion: handler)
        }

        public func transition(to providerType: Provider, completion handler: (() -> Void)? = nil) {
            self.baseType = providerType
            self.changeContainer(providerType.container, animated: true, completion: handler)
        }
    }
}
#endif

extension CBWindow.WindowContainer {
    func loadStack() -> CBStackView {
        let stackView = CBStackView()
        self.stackView = stackView
        return stackView
    }
}

public typealias WindowContainer<Provider: WindowContainerType> = CBWindow.WindowContainer<Provider>
