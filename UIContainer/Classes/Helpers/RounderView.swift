//
//  Rounder.swift
//  UIContainer
//
//  Created by brennobemoura on 25/09/19.
//

import Foundation
import UIKit
import EasyAnchor

public protocol Content {
    func addContent(_ view: UIView)
    func reloadContentLayout()
}

open class RounderView: View, Content {
    public var radius: CGFloat {
        didSet {
            self.reloadContentLayout()
        }
    }

    public required init(radius: CGFloat) {
        self.radius = radius
        super.init(frame: .zero)
    }

    public required init(_ view: UIView, radius: CGFloat) {
        self.radius = radius
        super.init(frame: .zero)
        self.addContent(view)
    }

    public func addContent(_ view: UIView) {
        AddSubview(self).addSubview(view)

        activate(
            view.anchor
                .edges
        )
        self.clipsToBounds = true
        self.reloadContentLayout()
    }

    public func reloadContentLayout() {
        if self.radius < 1 {
            self.layer.cornerRadius = self.frame.height * self.radius
        } else {
            self.layer.cornerRadius = self.radius
        }
    }
    
    override init(frame: CGRect) {
        fatalError()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()

        self.reloadContentLayout()
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
