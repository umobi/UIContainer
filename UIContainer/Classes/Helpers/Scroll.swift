//
//  Scroll.swift
//  UIContainer
//
//  Created by brennobemoura on 08/11/19.
//

import Foundation
import UIKit

open class ScrollView: UIScrollView {
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

        var onValidLayout: ((UIView) -> Void)? = nil
        override func layoutSubviews() {
            super.layoutSubviews()

            guard self.frame.size != .zero else {
                return
            }

            let onLayout = self.onValidLayout
            self.onValidLayout = nil
            onLayout?(self)
        }
    }

    public enum Axis {
        case vertical
        case horizontal
        case auto(vertical: UILayoutPriority, horizontal: UILayoutPriority)
    }

    private var onValidFrames: (() -> Void)? = nil
    private var onSuperview: ((UIView) -> Void)? = nil
    private weak var contentView: UIView!

    public required init(_ view: UIView, axis: Axis = .vertical) {
        super.init(frame: .zero)

        let contentView = ContentView(view)
        AddSubview(self).addSubview(contentView)
        self.contentView = contentView

        contentView.onValidLayout = { [weak self, axis] in
            $0.snp.makeConstraints {
                $0.edges.equalTo(0)
            }

            self?.onSuperview = { [axis] in

                self?.onValidFrames = { [axis] in
                    self?.setAxis(axis)
                }

                self?.contentView?.setNeedsLayout()
                self?.setNeedsLayout()
                for superview in sequence(first: $0, next: { $0.superview }) {
                    superview.setNeedsLayout()

                    if superview.frame.size != .zero {
                        superview.layoutIfNeeded()
                        break
                    }
                }
            }
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        guard let superview = self.superview else {
            return
        }

        if let onSubview = self.onSuperview {
            self.onSuperview = nil
            onSubview(superview)
            return
        }
        
        guard let onValidFrames = self.onValidFrames else {
            return
        }

        self.onValidFrames = nil
        onValidFrames()
    }

    public func setAxis(_ axis: Axis) {
        guard let superview = self.superview else {
            return
        }

        self.contentSize = self.contentView.frame.size

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

        self.setNeedsLayout()
        self.layoutIfNeeded()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
