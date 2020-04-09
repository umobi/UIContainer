//
//  Dashed.swift
//  Fujioka
//
//  Created by brennobemoura on 09/10/19.
//  Copyright © 2019 Umobi. All rights reserved.
//

import Foundation
import UIKit
import ConstraintBuilder

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

        guard let view = self.view else {
            return
        }

        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        self.shape.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: view.layer.cornerRadius).cgPath
        self.shape.frame = self.bounds
        self.shape.cornerRadius = self.subviews.first!.layer.cornerRadius
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
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
