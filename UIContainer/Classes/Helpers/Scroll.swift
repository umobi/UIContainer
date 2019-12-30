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

    public required init(_ view: UIView, axis: Axis = .vertical) {
        super.init(frame: .zero)
        self.addSubview(view)
        view.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        
        self.setAxis(axis)
    }

    public func setAxis(_ axis: Axis) {
        self.subviews.first!.snp.remakeConstraints {
            $0.edges.equalTo(0)
            switch axis {
            case .vertical:
                $0.width.equalTo(self.snp.width).priority(.required)
                $0.height.equalTo(self.snp.height).priority(.low)
            case .horizontal:
                $0.height.equalTo(self.snp.width).priority(.required)
                $0.width.equalTo(self.snp.height).priority(.low)
            case .auto(let vertical, let horizontal):
                $0.height.equalTo(self.snp.width).priority(vertical)
                $0.width.equalTo(self.snp.height).priority(horizontal)
            }
        }
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
