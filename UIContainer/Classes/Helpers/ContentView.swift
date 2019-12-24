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

open class ContentView: View {
    
    public required init(_ view: UIView!, contentMode: UIView.ContentMode, priority: ConstraintPriority = .required) {
        super.init(frame: .zero)
        self.addSubview(view)
        view.snp.makeConstraints { $0.edges.equalTo(0).priority(priority) }
        self.reload(contentMode: contentMode, priority: priority)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func reload(contentMode: UIView.ContentMode, priority: ConstraintPriority) {
        let view = self.subviews.first!
        view.removeFromSuperview()
        self.addSubview(view)
        
        switch contentMode {
        case .bottom:
            view.snp.makeConstraints {
                $0.bottom.equalTo(0).priority(priority)
                $0.centerX.equalTo(self.snp.centerX).priority(priority)
                $0.top.leading.greaterThanOrEqualTo(0).priority(priority)
                $0.trailing.lessThanOrEqualTo(0).priority(priority)
            }
        case .bottomLeft:
            view.snp.makeConstraints {
                $0.bottom.leading.equalTo(0).priority(priority)
                $0.top.greaterThanOrEqualTo(0).priority(priority)
                $0.trailing.lessThanOrEqualTo(0).priority(priority)
            }
            
        case .bottomRight:
            view.snp.makeConstraints {
                $0.bottom.trailing.equalTo(0).priority(priority)
                $0.top.leading.greaterThanOrEqualTo(0).priority(priority)
            }
        case .center:
            view.snp.makeConstraints {
                $0.top.leading.greaterThanOrEqualTo(0).priority(priority)
                $0.bottom.trailing.lessThanOrEqualTo(0).priority(priority)
                $0.center.equalTo(self.snp.center).priority(priority)
            }
            
        case .left:
            view.snp.makeConstraints {
                $0.top.greaterThanOrEqualTo(0).priority(priority)
                $0.bottom.trailing.lessThanOrEqualTo(0).priority(priority)
                $0.leading.equalTo(0).priority(priority)
                $0.centerY.equalTo(self.snp.centerY).priority(priority)
            }
            
        case .right:
            view.snp.makeConstraints {
                $0.top.leading.greaterThanOrEqualTo(0).priority(priority)
                $0.bottom.lessThanOrEqualTo(0).priority(priority)
                $0.trailing.equalTo(0).priority(priority)
                $0.centerY.equalTo(self.snp.centerY).priority(priority)
            }
            
        case .top:
            view.snp.makeConstraints {
                $0.top.equalTo(0).priority(priority)
                $0.trailing.bottom.lessThanOrEqualTo(0).priority(priority)
                $0.leading.greaterThanOrEqualTo(0).priority(priority)
                $0.centerX.equalTo(self.snp.centerX).priority(priority)
            }
            
        case .topLeft:
            view.snp.makeConstraints {
                $0.top.leading.equalTo(0).priority(priority)
                $0.bottom.trailing.lessThanOrEqualTo(0).priority(priority)
            }
                
        case .topRight:
            view.snp.makeConstraints {
                $0.top.trailing.equalTo(0).priority(priority)
                $0.bottom.lessThanOrEqualTo(0).priority(priority)
                $0.leading.greaterThanOrEqualTo(0).priority(priority)
            }
        case .scaleAspectFill: fallthrough
        case .scaleToFill: fallthrough
        case .redraw: fallthrough
        case .scaleAspectFit: fallthrough
        @unknown default:
            view.snp.makeConstraints { $0.edges.equalTo(0).priority(priority) }
        }
    }
}

public extension ContentView {
    func apply(contentMode: UIView.ContentMode) {
        self.reload(contentMode: contentMode, priority: .high)
    }

    func apply(priority: ConstraintPriority) {
        self.reload(contentMode: contentMode, priority: priority)
    }
}

public extension ContentView {
    class func Center(_ view: UIView) -> ContentView {
        return .init(view, contentMode: .center)
    }
    
    class func TopLeft(_ view: UIView) -> ContentView {
        return .init(view, contentMode: .topLeft)
    }
    
    class func Top(_ view: UIView) -> ContentView {
        return .init(view, contentMode: .top)
    }
    
    class func TopRight(_ view: UIView) -> ContentView {
        return .init(view, contentMode: .topRight)
    }
    
    class func Left(_ view: UIView) -> ContentView {
        return .init(view, contentMode: .left)
    }
    
    class func Right(_ view: UIView) -> ContentView {
        return .init(view, contentMode: .right)
    }
    
    class func BottomLeft(_ view: UIView) -> ContentView {
        return .init(view, contentMode: .bottomLeft)
    }
    
    class func Bottom(_ view: UIView) -> ContentView {
        return .init(view, contentMode: .bottom)
    }
    
    class func BottomRight(_ view: UIView) -> ContentView {
        return .init(view, contentMode: .bottomRight)
    }
}
