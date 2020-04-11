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
import ConstraintBuilder

public protocol WindowContainerType {
    var container: UIView! { get }
    
    static func launcher(in windowContainer: WindowContainer<Self>) -> UIView!

    static var showDebugView: Bool { get }
    
}

public extension WindowContainerType {
    static var showDebugView: Bool {
        return false
    }
}

class DebugView: View {
    override func prepare() {
        super.prepare()

        let label = OneLineLabel()
        label.text = "DEBUG"
        label.textColor = .red
        label.font = UIFont.boldSystemFont(ofSize: 16.0)

        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .horizontal)

        let content = ContentView.Right(label)

        Constraintable.activate(
            label.cbuild
                .leading
        )

        AddSubview(self).addSubview(content)

        Constraintable.activate(
            content.cbuild
                .top,

            content.cbuild
                .trailing,

            content.cbuild
                .bottom
                .equalTo(self.cbuild.topMargin)
        )
    }
}