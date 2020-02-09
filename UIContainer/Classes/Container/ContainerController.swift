//
//  Container.swift
//  mercadoon
//
//  Created by brennobemoura on 02/09/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation
import UIKit

public class ViewControllerMaker {
    private let view: (UIViewController) -> Void
    
    private init(_ view: @escaping (UIViewController) -> Void) {
        self.view = view
    }
    
    public static func dynamic(_ view: @escaping (UIViewController) -> Void) -> ViewControllerMaker {
        return .init(view)
    }
    
    func make(inside viewController: UIViewController!) {
        self.view(viewController)
    }
}

public protocol ViewControllerLoadStates {
    func viewDidLoad()
}

public protocol ViewControllerAppearStates {
    func viewWillAppear(_ animated: Bool)
    func viewDidAppear(_ animated: Bool)
    func viewWillDisappear(_ animated: Bool)
    func viewDidDisappear(_ animated: Bool)
}

public protocol ViewControllerType {
    var content: ViewControllerMaker { get }
}

public extension ViewControllerLoadStates {
    func viewDidLoad() {}
}

public extension ViewControllerAppearStates {
    func viewWillAppear(_ animated: Bool) {}
    func viewDidAppear(_ animated: Bool) {}
    func viewWillDisappear(_ animated: Bool) {}
    func viewDidDisappear(_ animated: Bool) {}
}

private var navigationKey: UInt = 0

public extension ViewControllerType {
    var navigationItem: UINavigationItem {
        guard let nav = objc_getAssociatedObject(self, &navigationKey) as? UINavigationItem else {
            let nav: UINavigationItem = .init()
            objc_setAssociatedObject(self, &navigationKey, nav, .OBJC_ASSOCIATION_RETAIN)
            return nav
        }

        return nav
    }
}

public class ContainerController<View: ViewControllerType>: UIViewController {
    private var appendView: View? = nil

    public private(set) var contentView: View! {
        willSet {
            self.appendView = nil
        }
    }

    override public var navigationItem: UINavigationItem {
        return (self.appendView ?? self.contentView).navigationItem
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    public init(_ view: View) {
        self.appendView = view
        super.init(nibName: nil, bundle: nil)
    }

    public init(content: () -> View) {
        self.appendView = content()
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        guard let contentView = self.appendView else {
            fatalError()
        }

        let content = contentView.content
        self.contentView = contentView
        content.make(inside: self)

        (self.contentView as? ViewControllerLoadStates)?.viewDidLoad()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (self.contentView as? ViewControllerAppearStates)?.viewWillAppear(animated)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (self.contentView as? ViewControllerAppearStates)?.viewDidAppear(animated)
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        (self.contentView as? ViewControllerAppearStates)?.viewWillDisappear(animated)
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
       super.viewDidDisappear(animated)
       (self.contentView as? ViewControllerAppearStates)?.viewDidDisappear(animated)
    }

    @available(iOS 11.0, tvOS 11, *)
    override public func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        self.view.setNeedsUpdateConstraints()
    }
}
