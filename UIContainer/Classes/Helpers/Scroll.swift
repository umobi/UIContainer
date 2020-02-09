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

    private var onSuperview: (() -> Void)? = nil
    private weak var contentView: UIView!

    public required init(_ view: UIView, axis: Axis = .vertical) {
        super.init(frame: .zero)

        self.contentView = view
        self.onSuperview = { [weak self, view] in
            AddSubview(self)?.addSubview(view)
            self?.setAxis(axis)
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        guard self.superview != nil && self.frame.size != .zero else {
            return
        }

        self.onSuperview?()
        self.onSuperview = nil
    }

    public func setAxis(_ axis: Axis) {
        guard let superview = self.superview else {
            return
        }

        self.contentView!.snp.remakeConstraints {
            $0.edges.equalTo(0)
            switch axis {
            case .vertical:
                $0.width.equalTo(superview.snp.width).priority(.required)
                $0.height.equalTo(superview.snp.height).priority(UILayoutPriority.fittingSizeLevel)
            case .horizontal:
                $0.height.equalTo(superview.snp.width).priority(.required)
                $0.width.equalTo(superview.snp.height).priority(UILayoutPriority.fittingSizeLevel)
            case .auto(let vertical, let horizontal):
                $0.height.equalTo(superview.snp.width).priority(vertical)
                $0.width.equalTo(superview.snp.height).priority(horizontal)
            }
        }
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
