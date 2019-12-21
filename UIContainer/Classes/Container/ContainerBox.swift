//
//  ContainerBox.swift
//  Pods
//
//  Created by brennobemoura on 16/10/19.
//

import Foundation
import UIKit
import SnapKit

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
            self.view.addSubview(view)
        }() : {
            super.addSubview(view)

            view.snp.makeConstraints {
                $0.edges.equalTo(0)
            }
        }()
    }

    override open func insertSubview(_ view: UIView, at index: Int) {
        self.cannotAddViews ?  {
               self.view.insertSubview(view, at: index)
           }() : {
            super.insertSubview(view, at: index)

            view.snp.makeConstraints {
                $0.edges.equalTo(0)
            }
        }()
    }

    override open func insertSubview(_ view: UIView, aboveSubview siblingSubview: UIView) {
        self.cannotAddViews ? {
            if siblingSubview == self.view {
                self.view.insertSubview(view, at: 0)
            } else {
                self.view.insertSubview(view, aboveSubview: siblingSubview)
            }
        }() : {
            super.insertSubview(view, aboveSubview: siblingSubview)

            view.snp.makeConstraints {
                $0.edges.equalTo(0)
            }
        }()
    }

    override open func insertSubview(_ view: UIView, belowSubview siblingSubview: UIView) {
        self.cannotAddViews ? () : {
            super.insertSubview(view, belowSubview: siblingSubview)

            view.snp.makeConstraints {
                $0.edges.equalTo(0)
            }
        }()
    }
}
