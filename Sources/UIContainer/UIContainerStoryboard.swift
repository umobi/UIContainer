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

public protocol UIContainerStoryboard: View, ContainerRepresentable where View == Container.View {
    associatedtype Container: ContainerRepresentable
    var containerView: Container! { get set }

    func addContainer(_ container: Container)

    var edgeInsets: CTEdgeInsets { get set }
}

public extension UIContainerStoryboard {
    weak var view: Container.View! {
        get {
            return self.containerView.view
        }

        set {
            self.containerView.view = newValue
        }
    }

    weak var parent: ParentView! {
        return self.containerView.parent
    }

    func removeContainer() {
        fatalError("Don't try to remove ContainerStoryboard")
    }

    func insertContainer(view: View!) {
        fatalError("Don't try to insert in ContainerCell")
    }

    func prepareContainer(inside parentView: ParentView!, loadHandler: (() -> View?)? = nil) {
        if loadHandler != nil {
            fatalError("ContainerStoryboard should not be prepared with loadHandler")
        }

        if self.containerView != nil {
            return
        }

        let containerView = Container(in: parentView, loadHandler: loadHandler)
        self.containerView = containerView
        self.addContainer(containerView)

        self.containerDidLoad()
    }

    func prepareContainer(inside parentView: ParentView!, edgeInsets: CTEdgeInsets) {
        self.edgeInsets = edgeInsets
        self.prepareContainer(inside: parentView)
    }

    init(in parentView: ParentView!, loadHandler: (() -> View?)?) {
        fatalError("ContainerStoryboard should not be instanciated by code")
    }
}

public extension UIContainerStoryboard where Container: CBView {
    func addContainer(_ container: Container) {
        let edgeInsets = self.edgeInsets
        let view = self.loadView(container)
        CBSubview(self).insertSubview(view, at: 0)

        view.applyEdges(edgeInsets)
    }
}
