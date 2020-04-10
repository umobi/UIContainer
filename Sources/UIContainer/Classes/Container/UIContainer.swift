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

public protocol ContainerType: class {

}

public protocol ContainerRepresentable: ContainerType {
    typealias ParentView = UIViewController
    associatedtype View: AnyObject
    
    var view: View! { get set }
    var parent: ParentView! { get set }
    
    func prepareContainer(inside parentView: ParentView!, loadHandler: (() -> View?)?)
    
    func removeContainer()
    
    func insertContainer(view: View!)
    
    func prepare(parentView: ParentView!)
    
    func spacer<T: UIView>(_ view: T) -> SpacerView
    
    func containerDidLoad()
    
    init(in parentView: ParentView!, loadHandler: (() -> View?)?)
}

public extension ContainerRepresentable {
    func prepare(parentView: ParentView!) {
        self.parent = parentView
    }
    
    func spacer<T: UIView>(_ view: T) -> SpacerView {
        return .init(view, spacing: 0)
    }
}
