//
//  Rounder.swift
//  UIContainer
//
//  Created by brennobemoura on 25/09/19.
//

import Foundation
import UIKit
import SnapKit

class Rounder: UIView {
    let radius: CGFloat
    init(_ view: UIView, radius: CGFloat) {
        self.radius = radius
        super.init(frame: .zero)
        
        self.addSubview(view)
        view.snp.makeConstraints { $0.edges.equalTo(0) }
        self.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        fatalError()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if radius < 1 {
            self.cornerRadius = self.frame.height * radius
        } else {
            self.cornerRadius = radius
        }
    }
    
    static func full(_ view: UIView) -> Rounder {
        return .init(view, radius: 0.5)
    }
    
    func border(width: CGFloat, color: UIColor?) {
        self.borderWidth = width
        self.borderColor = color
    }
}

extension Rounder {
    
    @discardableResult
    func border(width: CGFloat) -> Self {
        self.border(width: width, color: self.borderColor)
        return self
    }
    
    @discardableResult
    func border(color: UIColor?) -> Self {
        self.border(width: self.borderWidth, color: color)
        return self
    }
}

extension Rounder {
    
    @discardableResult
    static func outside(_ view: UIView!, radius: CGFloat) -> Rounder {
        let view = view!
        let superview = view.superview!
        view.removeFromSuperview()
        
        let rounder = Rounder(view, radius: radius)
        superview.addSubview(rounder)
        
        rounder.snp.makeConstraints { $0.edges.equalTo(0) }
        return rounder
    }
}

extension UIImageView {
    
    var rounder: Rounder? {
        return self.superview as? Rounder
    }
    
    @IBInspectable
    var rounderRadius: CGFloat {
        get {
            return self.rounder?.radius ?? 0.0
        }
        
        set {
            guard newValue != self.rounderRadius else {
                return
            }
            
            if let rounder = self.rounder {
                let superview = self.rounder?.superview ?? self.superview
                rounder.removeFromSuperview()
                superview?.addSubview(self)
                
                if newValue == 0 {
                    self.snp.makeConstraints { $0.edges.equalTo(0) }
                    return
                }
            }
            
            Rounder.outside(self, radius: newValue)
        }
    }
}
