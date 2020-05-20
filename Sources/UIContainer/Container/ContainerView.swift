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

open class ContainerView<View: CBView & ContainerViewParent>: ContainerBox, ContainerRepresentable {

    public final weak var view: View!
    public weak var parent: ParentView!

    open override func removeFromSuperview() {
        self.removeContainer()
        super.removeFromSuperview()
    }

    open func containerDidLoad() {}

    open func loadView<T: CBView>(_ view: T) -> CBView {
        return view
    }

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

public extension ContainerRepresentable where Self: ContainerBox, View: CBView & ContainerViewParent {

    func prepareContainer(inside parentView: ParentView!, loadHandler: (() -> View?)? = nil) {
        self.prepare(parentView: parentView)

        guard let loader = loadHandler else {
            self.insertContainer(view: View())
            return
        }

        self.insertContainer(view: loader())
    }

    func removeContainer() {
        guard let view = view else {
            return
        }

        let spacer = view.superview
        view.removeFromSuperview()
        spacer?.removeFromSuperview()
    }

    func insertContainer(view: View!) {
        self.removeContainer()

        self.view = view
        self.view.parent = self.parent
        let spacer = self.edgeInsets
        let view = self.loadView(view)
        CBSubview(self).addSubview(view)

        view.applyEdges(spacer)
    }
}
