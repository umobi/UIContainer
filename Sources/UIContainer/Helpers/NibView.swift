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

open class NibView: View {
    @IBOutlet public weak var view: CBView!

    #if !os(macOS)
    open var className: String {
        return String(describing: type(of: self))
    }
    #endif

    open override func prepare() {
        super.prepare()
        self.loadFromNib()
    }

    private func loadFromNib() {
        #if !os(macOS)
        Bundle(for: type(of: self)).loadNibNamed("\(self.className)", owner: self, options: nil)
        #else
        Bundle(for: type(of: self)).loadNibNamed("\(self.className)", owner: self, topLevelObjects: nil)
        #endif

        CBSubview(self).addSubview(view)

        Constraintable.activate {
            view.cbuild
                .edges
        }
    }
}
