//
//  Rounder.swift
//  UIContainer
//
//  Created by brennobemoura on 25/09/19.
//

import Foundation
import UIKit
import EasyAnchor

open class RounderView: View {
    public var radius: CGFloat {
        willSet {
            self.update(radius: newValue)
        }
    }

    public required init(_ view: UIView, radius: CGFloat) {
        self.radius = radius
        super.init(frame: .zero)

        AddSubview(self).addSubview(view)

        activate(
            view.anchor
                .edges
        )

        self.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        fatalError()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        self.update(radius: self.radius)
    }

    private func update(radius: CGFloat) {
        if radius < 1 {
            self.layer.cornerRadius = self.frame.height * radius
        } else {
            self.layer.cornerRadius = radius
        }
    }

    public static func full(_ view: UIView) -> RounderView {
        return .init(view, radius: 0.5)
    }
    
    public func border(width: CGFloat, color: UIColor?) {
        self.layer.borderWidth = width
        self.layer.borderColor = color?.cgColor
    }
}

public extension RounderView {
    
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

public extension RounderView {
    
    @discardableResult
    static func outside(_ view: UIView!, radius: CGFloat) -> RounderView {
        let view = view!
        let superview = view.superview!
        view.removeFromSuperview()
        
        let rounder = RounderView(view, radius: radius)
        AddSubview(superview).addSubview(rounder)

        activate(
            rounder.anchor
                .edges
        )

        return rounder
    }
}

public extension UIImageView {
    
    var rounder: RounderView? {
        return self.superview as? RounderView
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
                AddSubview(superview)?.addSubview(self)
                
                if newValue == 0 {
                    activate(
                        self.anchor
                            .edges
                    )

                    return
                }
            }
            
            RounderView.outside(self, radius: newValue)
        }
    }
}
