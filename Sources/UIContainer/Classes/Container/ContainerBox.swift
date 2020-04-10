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
