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
#else
import UIKit
#endif

public class ViewControllerMaker {
    private let view: (CBViewController) -> Void
    
    private init(_ view: @escaping (CBViewController) -> Void) {
        self.view = view
    }
    
    public static func dynamic(_ view: @escaping (CBViewController) -> Void) -> ViewControllerMaker {
        return .init(view)
    }
    
    func make(inside viewController: CBViewController!) {
        self.view(viewController)
    }
}

public protocol ViewControllerLoadStates {
    func viewDidLoad()
}

public protocol ViewControllerType: class {
    var content: ViewControllerMaker { get }
}

public extension ViewControllerLoadStates {
    func viewDidLoad() {}
}

public protocol StatusBarAppearanceManager {
    #if os(iOS)
    var statusBarStyle: UIStatusBarStyle? { get nonmutating set }
    #endif
}

public class ContainerController<View: ViewControllerType>: CBViewController, StatusBarAppearanceManager {
    private var appendView: View? = nil

    public private(set) weak var contentView: View! {
        willSet {
            self.appendView = nil
        }
    }

    #if !os(macOS)
    override public var navigationItem: UINavigationItem {
        return (self.appendView ?? self.contentView).navigationItem
    }
    #endif
    
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

    #if !os(macOS)

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

    #else
    override public func viewWillAppear() {
        super.viewWillAppear()
        (self.contentView as? ViewControllerAppearStates)?.viewWillAppear()
    }

    override public func viewDidAppear() {
        super.viewDidAppear()
        (self.contentView as? ViewControllerAppearStates)?.viewDidAppear()
    }

    override public func viewWillDisappear() {
        super.viewWillDisappear()
        (self.contentView as? ViewControllerAppearStates)?.viewWillDisappear()
    }

    override public func viewDidDisappear() {
       super.viewDidDisappear()
       (self.contentView as? ViewControllerAppearStates)?.viewDidDisappear()
    }

    #endif
}
