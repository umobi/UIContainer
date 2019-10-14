//
//  Dashed.swift
//  Fujioka
//
//  Created by brennobemoura on 09/10/19.
//  Copyright © 2019 Umobi. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

public class Dashed: UIView {
    
    private(set) var strokeColor: UIColor = .clear
    private(set) var lineWidth: CGFloat = 1
    private(set) var dashPattern: [NSNumber]
    
    private var shape: CAShapeLayer!
    
    public init(_ view: UIView, dash pattern: [NSNumber]) {
        self.dashPattern = pattern
        super.init(frame: .zero)
        
        self.addSubview(view)
        view.snp.makeConstraints { $0.edges.equalTo(0) }
        
        self.reloadShape()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func reloadShape() {
        self.shape = self.shape ?? self.createShape()
        
        self.shape.strokeColor = strokeColor.cgColor
        self.shape.lineWidth = self.lineWidth
        self.shape.lineDashPattern = self.dashPattern
    }
    
    private func createShape() -> CAShapeLayer {
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
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: self.subviews.first!.layer.cornerRadius).cgPath

        self.layer.addSublayer(shapeLayer)
        
        return shapeLayer
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.subviews.first?.setNeedsLayout()
        self.subviews.first?.layoutIfNeeded()
        
        self.shape.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.subviews.first!.layer.cornerRadius).cgPath
        self.shape.frame = self.bounds
        self.shape.cornerRadius = self.subviews.first!.layer.cornerRadius
    }
}

public extension Dashed {
    
    func apply(strokeColor: UIColor) -> Dashed {
        self.strokeColor = strokeColor
        return self
    }
    
    func apply(lineWidth: CGFloat) -> Dashed {
        self.lineWidth = lineWidth
        return self
    }
    
    func apply(dashPattern: [NSNumber]) -> Dashed {
        self.dashPattern = dashPattern
        return self
    }
    
    func refresh() {
        self.reloadShape()
    }
}

public extension UIImageView {
    func dashed(with pattern: [NSNumber], cornerRadius: CGFloat = 0.0) -> Dashed {
        let superview = self.superview!
        self.removeFromSuperview()
        let dash = Dashed(Rounder(self, radius: cornerRadius), dash: pattern)
        superview.insertSubview(dash, at: 0)
        dash.snp.makeConstraints { $0.edges.equalTo(0) }
        
        return dash
    }
}
