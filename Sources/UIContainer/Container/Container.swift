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

open class Container<View: CBViewController>: ContainerBox, ContainerRepresentable {

    public weak var view: View!
    public weak var parent: ParentView!

    open override func removeFromSuperview() {
        super.removeFromSuperview()
        self.removeContainer()
    }

    open func containerDidLoad() {}

    public required init(in parentView: ParentView!, loadHandler: (() -> View?)? = nil) {
        super.init(frame: .zero)
        self.prepareContainer(inside: parentView, loadHandler: loadHandler)
        self.containerDidLoad()
    }

    public required init() {
        super.init(frame: .zero)
    }

    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension ContainerRepresentable where Self: ContainerBox, View: CBViewController {
    func prepareContainer(inside parentView: ParentView!, loadHandler: (() -> View?)? = nil) {
        self.prepare(parentView: parentView)

        guard let loader = loadHandler else {
            self.insertContainer(view: View.fromNib())
            return
        }

        self.insertContainer(view: loader())
    }

    func removeContainer() {
        guard let view = view else {
            return
        }

        let spacer = view.view.superview
        #if !os(macOS)
        view.willMove(toParent: nil)
        #else
        view.removeFromParent()
        #endif
        view.view.removeFromSuperview()
        spacer?.removeFromSuperview()
        view.removeFromParent()
    }

    func insertContainer(view: View!) {
        self.removeContainer()

        self.view = view
        parent?.addChild(view)

        let edgeInsets = self.edgeInsets
        let uiView = self.loadView(view.view)
        CBSubview(self).addSubview(uiView)

        uiView.applyEdges(edgeInsets)

        #if !os(macOS)
        view.didMove(toParent: self.parent)
        #else
        self.parent.addChild(view)
        #endif
    }
}
