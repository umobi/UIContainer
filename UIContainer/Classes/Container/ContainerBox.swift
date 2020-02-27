//
//  ContainerBox.swift
//  Pods
//
//  Created by brennobemoura on 16/10/19.
//

import Foundation
import UIKit

open class ContainerBox: UIView {
    var cannotAddViews: Bool {
        return self.view != nil
    }

    private var view: UIView! {
        return super.subviews.first
    }

    override open var subviews: [UIView] {
        return [self.view].compactMap { $0 } + (self.view?.subviews ?? [])
    }

    override open func addSubview(_ view: UIView) {
        self.cannotAddViews ? {
            AddSubview(self.view).addSubview(view)
        }() : {
            super.addSubview(view)
        }()
    }

    override open func insertSubview(_ view: UIView, at index: Int) {
        self.cannotAddViews ?  {
                AddSubview(self.view).insertSubview(view, at: index)
           }() : {
            super.insertSubview(view, at: index)
        }()
    }

    override open func insertSubview(_ view: UIView, aboveSubview siblingSubview: UIView) {
        self.cannotAddViews ? {
            if siblingSubview == self.view {
                AddSubview(self.view).insertSubview(view, at: 0)
            } else {
                self.view.insertSubview(view, aboveSubview: siblingSubview)
            }
        }() : {
            super.insertSubview(view, aboveSubview: siblingSubview)
        }()
    }

    override open func insertSubview(_ view: UIView, belowSubview siblingSubview: UIView) {
        self.cannotAddViews ? () : {
            super.insertSubview(view, belowSubview: siblingSubview)
        }()
    }
}
