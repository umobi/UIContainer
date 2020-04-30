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

@available(*, deprecated, message: "use UICDashedView from UICreator")
open class DashedView: View, Content {

    weak var view: UIView?
    private(set) var strokeColor: UIColor = .clear
    private(set) var lineWidth: CGFloat = 1
    private(set) var dashPattern: [NSNumber]
    
    private var shape: CAShapeLayer!
    
    public required init(_ view: UIView, dash pattern: [NSNumber]) {
        self.dashPattern = pattern
        super.init(frame: .zero)
        self.addContent(view)
    }

    public required init(dash pattern: [NSNumber]) {
        self.dashPattern = pattern
        super.init(frame: .zero)
    }

    public func addContent(_ view: UIView) {
        AddSubview(self).addSubview(view)

        Constraintable.activate(
            view.cbuild
                .edges
        )

        self.view = view
    }

    public func reloadContentLayout() {
        self.shape = self.shape ?? self.createShape()

        self.shape.strokeColor = strokeColor.cgColor
        self.shape.lineWidth = self.lineWidth
        self.shape.lineDashPattern = self.dashPattern
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createShape() -> CAShapeLayer {
        guard let view = self.view else {
            return CAShapeLayer()
        }

        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = self.lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = self.dashPattern
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: view.layer.cornerRadius).cgPath

        self.layer.addSublayer(shapeLayer)
        
        return shapeLayer
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()

        func prepareToReload() {
            guard let view = self.view else {
                return
            }

            view.setNeedsLayout()
            view.layoutIfNeeded()

            self.shape.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: view.layer.cornerRadius).cgPath
            self.shape.frame = self.bounds
            self.shape.cornerRadius = self.subviews.first!.layer.cornerRadius
        }
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.reloadContentLayout()
    }
}

public extension DashedView {
    
    func apply(strokeColor: UIColor) -> Self {
        self.strokeColor = strokeColor
        return self
    }
    
    func apply(lineWidth: CGFloat) -> Self {
        self.lineWidth = lineWidth
        return self
    }
    
    func apply(dashPattern: [NSNumber]) -> Self {
        self.dashPattern = dashPattern
        return self
    }
    
    func refresh() {
        self.reloadContentLayout()
    }
}

public extension UIImageView {
    func dashed(with pattern: [NSNumber], cornerRadius: CGFloat = 0.0) -> DashedView {
        let superview = self.superview!
        self.removeFromSuperview()
        let dash = DashedView(RounderView(self, radius: cornerRadius), dash: pattern)
        AddSubview(superview).insertSubview(dash, at: 0)

        Constraintable.activate(
            dash.cbuild
                .edges
        )
        
        return dash
    }
}

extension UIView {
    func layoutCenter() {
        Constraintable.activate(
            self.cbuild
                .top
                .bottom
                .greaterThanOrEqualTo(0),

            self.cbuild
                .leading
                .trailing
                .greaterThanOrEqualTo(0),

            self.cbuild
                .center
        )
    }
}
