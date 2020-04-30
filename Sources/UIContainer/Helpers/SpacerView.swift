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

@available(*, deprecated, message: "use UICSpacerView from UICreator")
open class SpacerView: View, Content {
    private weak var view: UIView?
    let margin: SpacerView.Margin

    public required init(margin: Margin) {
        self.margin = margin
        super.init(frame: .zero)
    }

    public required init(_ view: UIView!, margin: Margin) {
        self.margin = margin
        super.init(frame: .zero)
        
        self.addContent(view)
    }
    
    public convenience init(_ view: UIView!, top: CGFloat, bottom: CGFloat, leading: CGFloat, trailing: CGFloat) {
        self.init(view, margin: .init(top: top, bottom: bottom, leading: leading, trailing: trailing))
    }
    
    private func layout() {
        guard let view = self.view else {
            return
        }

        Constraintable.update(
            view.cbuild
                .top
                .equalTo(self)
                .update()
                .constant(self.margin.top),

            view.cbuild
                .bottom
                .equalTo(self)
                .update()
                .constant(self.margin.bottom),

            view.cbuild
                .trailing
                .equalTo(self)
                .update()
                .constant(self.margin.trailing),

            view.cbuild
                .leading
                .equalTo(self)
                .update()
                .constant(self.margin.leading)
        )
    }

    public func addContent(_ view: UIView) {
        self.view = view
        AddSubview(self).addSubview(view)
        self.layout()
    }

    public func reloadContentLayout() {
        guard self.view != nil else {
            return
        }

        self.layout()
    }

    public convenience init(_ view: UIView!, vertical: CGFloat, horizontal: CGFloat) {
        self.init(view, margin: .init(vertical: vertical, horizontal: horizontal))
    }
    
    public convenience init(_ view: UIView!, spacing: CGFloat) {
        self.init(view, margin: .init(spacing: spacing))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("No aDecoder implemented")
    }
}
