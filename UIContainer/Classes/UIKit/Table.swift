//
//  Table.swift
//  UIContainer
//
//  Created by brennobemoura on 13/12/19.
//

import Foundation

public protocol HasContainer: ContainerViewParent {
    associatedtype Container: UIContainer where Container: UIView, Container.View == Self

}

extension HasContainer {
    func loadContainer(in parentView: Container.ParentView!) -> Container {
        return .init(in: parentView) { [weak self] in self }
    }
}

open class Table: UITableView, ContainerViewParent {
    weak public var parent: UIViewController!

    open func prepare() {}

    public init(style: UITableView.Style = .grouped) {
        super.init(frame: .zero, style: style)
        self.prepare()
    }

    override public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.prepare()
    }

    required public init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}

public extension ViewControllerType where Self: HasContainer {
    var content: ViewControllerMaker {
        return .dynamic { viewController in
            let container = self.loadContainer(in: viewController)
            viewController.view.addSubview(container)
            container.snp.makeConstraints {
                $0.edges.equalTo(0)
            }
        }
    }
}
