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

public protocol ViewControllerType: UIView {
    var content: ViewControllerMaker { get }
    
    func viewWillAppear(_ animated: Bool)
    func viewDidAppear(_ animated: Bool)
    func viewWillDisappear(_ animated: Bool)
    func viewDidDisappear(_ animated: Bool)
}

public extension ViewControllerType {
    func viewWillAppear(_ animated: Bool) {}
    func viewDidAppear(_ animated: Bool) {}
    func viewWillDisappear(_ animated: Bool) {}
    func viewDidDisappear(_ animated: Bool) {}
}

public class ContainerController<View: ViewControllerType>: UIViewController {
    weak var contentView: View!
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public init(_ view: View) {
        self.contentView = view
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        let contentView = self.contentView ?? View.init()
        let content = contentView.content
        self.contentView = contentView
        super.viewDidLoad()
        content.make(inside: self)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.contentView.viewWillAppear(animated)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.contentView.viewDidAppear(animated)
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.contentView.viewWillDisappear(animated)
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
       super.viewDidDisappear(animated)
       self.contentView.viewDidDisappear(animated)
   }
}
