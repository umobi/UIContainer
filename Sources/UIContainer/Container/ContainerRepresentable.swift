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

#if os(macOS)
import AppKit
public typealias CTEdgeInsets = NSEdgeInsets
#else
import UIKit
public typealias CTEdgeInsets = UIEdgeInsets
#endif

public protocol ContainerType: class {

}

public protocol ContainerRepresentable: ContainerType {
    typealias ParentView = CBViewController
    associatedtype View: AnyObject
    
    var view: View! { get set }
    var parent: ParentView! { get set }
    
    func prepareContainer(inside parentView: ParentView!, loadHandler: (() -> View?)?)
    
    func removeContainer()
    
    func insertContainer(view: View!)
    
    func prepare(parentView: ParentView!)

    func loadView<T: CBView>(_ view: T) -> CBView
    var edgeInsets: CTEdgeInsets { get }
    
    func containerDidLoad()
    
    init(in parentView: ParentView!, loadHandler: (() -> View?)?)
}

public extension ContainerRepresentable {
    func prepare(parentView: ParentView!) {
        self.parent = parentView
    }

    func loadView<T: CBView>(_ view: T) -> CBView {
        return view
    }

    var edgeInsets: CTEdgeInsets {
        return .zero
    }
}

#if os(macOS)
extension CTEdgeInsets {
    static var zero: CTEdgeInsets {
        .init(top: 0, left: 0, bottom: 0, right: 0)
    }
}
#endif
