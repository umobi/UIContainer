//
//  Scroll.swift
//  UIContainer
//
//  Created by brennobemoura on 08/11/19.
//

import Foundation
import UIKit

private extension UIView {
    func setNeedsLayoutOnTree() {
        self.subviews.forEach {
            $0.setNeedsLayoutOnTree()
        }

        self.setNeedsLayout()
    }

    func setNeedsConstraintOnTree() {
        self.subviews.forEach {
            $0.setNeedsConstraintOnTree()
        }

        self.setNeedsUpdateConstraints()
    }
}

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
    private var onSuperview: (() -> Void)? = nil
    private var onWindow: (() -> Void)? = nil
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
                let onWindow = { [axis] in
                    guard let self = self else {
                        return
                    }

                    self.onValidFrames = { [weak self, axis] in
                        self?.setAxis(axis)
                    }

                    var topSuperview: UIView! = self.superview
                    for superview in sequence(first: topSuperview, next: { $0.superview }) {
                        topSuperview = superview

                        if superview.frame.size != .zero {
                            break
                        }
                    }

                    topSuperview.setNeedsConstraintOnTree()
                    topSuperview.setNeedsLayoutOnTree()
                    topSuperview.layoutIfNeeded()
                }

                if self?.window != nil {
                    onWindow()
                    return
                }

                self?.onWindow = onWindow
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
            onSubview()
            return
        }
        
        guard let onValidFrames = self.onValidFrames else {
            return
        }

        self.onValidFrames = nil
        onValidFrames()
    }

    override open func didMoveToWindow() {
        super.didMoveToWindow()

        guard self.window != nil, let onWindow = self.onWindow else {
            return
        }

        self.onWindow = nil
        onWindow()
    }

    public func setAxis(_ axis: Axis) {
        guard let superview = self.superview else {
            return
        }

        self.contentSize = self.contentView.frame.size

        #if DEBUG
        print("[UIContainer] WARNING: - ScrollView may cause constraint errors, looking for solution")
        #endif
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

        #if DEBUG
        print("[UIContainer] WARNING: - If Layout Engine throws some constraints error, please ignore while a fix is finded. This error happens because superviews have width or height equal to 0 and the content inside scrollview should have width or height at least grather than or equal to some x vale.")
        #endif
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
