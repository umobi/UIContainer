//
//  Scroll.swift
//  UIContainer
//
//  Created by brennobemoura on 08/11/19.
//

import Foundation
import UIKit

open class ScrollView: UIScrollView {

    public enum Axis {
        case vertical
        case horizontal
        case auto(vertical: UILayoutPriority, horizontal: UILayoutPriority)
    }

    private weak var contentView: UIView!

    public required init(_ view: UIView, axis: Axis = .vertical) {
        super.init(frame: .zero)

        let contentView = ContentView(view)
        AddSubview(self).addSubview(contentView)
        self.contentView = contentView

        self.setAxis(axis)
    }

    public func setAxis(_ axis: Axis) {
        self.contentView!.snp.remakeConstraints {
            $0.edges.equalTo(0)
            switch axis {
            case .vertical:
                $0.width.equalTo(self.snp.width).priority(.required)
                $0.height.equalTo(self.snp.height).priority(UILayoutPriority.fittingSizeLevel)
            case .horizontal:
                $0.height.equalTo(self.snp.height).priority(.required)
                $0.width.equalTo(self.snp.width).priority(UILayoutPriority.fittingSizeLevel)
            case .auto(let vertical, let horizontal):
                $0.height.equalTo(self.snp.height).priority(vertical)
                $0.width.equalTo(self.snp.width).priority(horizontal)
            }
        }
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ScrollView {
    class ContentView: UIView {
        weak var view: UIView!

        convenience init(_ view: UIView) {
            self.init(frame: .zero)
            self.view = view

            AddSubview(self).addSubview(view)

            view.snp.makeConstraints {
                $0.edges.equalTo(0)
            }
        }
    }
}
