//
//  Rounder.swift
//  UIContainer
//
//  Created by brennobemoura on 25/09/19.
//

import Foundation
import UIKit
import SnapKit

public class Rounder: View {
    let radius: CGFloat
    public init(_ view: UIView, radius: CGFloat) {
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
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if radius < 1 {
            self.layer.cornerRadius = self.frame.height * radius
        } else {
            self.layer.cornerRadius = radius
        }
    }
    
    public static func full(_ view: UIView) -> Rounder {
        return .init(view, radius: 0.5)
    }
    
    public func border(width: CGFloat, color: UIColor?) {
        self.layer.borderWidth = width
        self.layer.borderColor = color?.cgColor
    }
}

public extension Rounder {
    
    @discardableResult
    func border(width: CGFloat) -> Self {
        guard let color = self.layer.borderColor else {
            self.border(width: width, color: UIColor.clear)
            return self
        }
        
        self.border(width: width, color: UIColor(cgColor: color))
        return self
    }
    
    @discardableResult
    func border(color: UIColor?) -> Self {
        self.border(width: self.layer.borderWidth, color: color)
        return self
    }
}

public extension Rounder {
    
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

public extension UIImageView {
    
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
