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

open class ContainerBox: CBView {
    var cannotAddViews: Bool {
        return self.view != nil
    }

    private var view: CBView! {
        return super.subviews.first
    }

    #if !os(macOS)
    override open var subviews: [CBView] {
        return [self.view].compactMap { $0 } + (self.view?.subviews ?? [])
    }
    #else
    override open var subviews: [CBView] {
        get {
            return [self.view].compactMap { $0 } + (self.view?.subviews ?? [])
        }
        set {
            super.subviews = newValue.filter { $0 !== self }
        }
    }
    #endif


    override open func addSubview(_ view: CBView) {
        self.cannotAddViews ? {
            CBSubview(self.view).addSubview(view)
        }() : {
            super.addSubview(view)
        }()
    }

    #if !os(macOS)
    override open func insertSubview(_ view: CBView, at index: Int) {
        self.cannotAddViews ?  {
                CBSubview(self.view).insertSubview(view, at: index)
           }() : {
            super.insertSubview(view, at: index)
        }()
    }

    override open func insertSubview(_ view: CBView, aboveSubview siblingSubview: CBView) {
        self.cannotAddViews ? {
            if siblingSubview == self.view {
                CBSubview(self.view).insertSubview(view, at: 0)
            } else {
                self.view.insertSubview(view, aboveSubview: siblingSubview)
            }
        }() : {
            super.insertSubview(view, aboveSubview: siblingSubview)
        }()
    }

    override open func insertSubview(_ view: CBView, belowSubview siblingSubview: CBView) {
        self.cannotAddViews ? () : {
            super.insertSubview(view, belowSubview: siblingSubview)
        }()
    }

    #else
    open override func addSubview(_ view: CBView, positioned place: CBWindow.OrderingMode, relativeTo otherView: CBView?) {
        self.cannotAddViews ? {
            if otherView == self.view {
                CBSubview(otherView)?.insertSubview(view, at: 0)
            } else {
                self.view.addSubview(view, positioned: place, relativeTo: otherView)
            }
        }() : {
            super.addSubview(view, positioned: place, relativeTo: otherView)
        }()
    }
    #endif
}
