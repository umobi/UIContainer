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

public class Content: UIView {
    
    public init(_ view: UIView!, contentMode: UIView.ContentMode) {
        super.init(frame: .zero)
        self.addSubview(view)
        view.snp.makeConstraints { $0.edges.equalTo(0) }
        self.reload(contentMode: contentMode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func reload(contentMode: UIView.ContentMode) {
        let view = self.subviews.first!
        view.removeFromSuperview()
        self.addSubview(view)
        
        switch contentMode {
        case .bottom:
            view.snp.makeConstraints {
                $0.bottom.equalTo(0)
                $0.centerX.equalTo(self.snp.centerX)
                $0.top.leading.greaterThanOrEqualTo(0)
                $0.trailing.lessThanOrEqualTo(0)
            }
        case .bottomLeft:
            view.snp.makeConstraints {
                $0.bottom.leading.equalTo(0)
                $0.top.greaterThanOrEqualTo(0)
                $0.trailing.lessThanOrEqualTo(0)
            }
            
        case .bottomRight:
            view.snp.makeConstraints {
                $0.bottom.trailing.equalTo(0)
                $0.top.leading.greaterThanOrEqualTo(0)
            }
        case .center:
            view.snp.makeConstraints {
                $0.top.leading.greaterThanOrEqualTo(0)
                $0.bottom.trailing.lessThanOrEqualTo(0)
                $0.center.equalTo(self.snp.center)
            }
            
        case .left:
            view.snp.makeConstraints {
                $0.top.greaterThanOrEqualTo(0)
                $0.bottom.trailing.lessThanOrEqualTo(0)
                $0.leading.equalTo(0)
                $0.centerY.equalTo(self.snp.centerY)
            }
            
        case .right:
            view.snp.makeConstraints {
                $0.top.leading.greaterThanOrEqualTo(0)
                $0.bottom.lessThanOrEqualTo(0)
                $0.trailing.equalTo(0)
                $0.centerY.equalTo(self.snp.centerY)
            }
            
        case .top:
            view.snp.makeConstraints {
                $0.top.equalTo(0)
                $0.trailing.bottom.lessThanOrEqualTo(0)
                $0.leading.greaterThanOrEqualTo(0)
                $0.centerX.equalTo(self.snp.centerX)
            }
            
        case .topLeft:
            view.snp.makeConstraints {
                $0.top.leading.equalTo(0)
                $0.bottom.trailing.lessThanOrEqualTo(0)
            }
                
        case .topRight:
            view.snp.makeConstraints {
                $0.top.trailing.equalTo(0)
                $0.bottom.lessThanOrEqualTo(0)
                $0.leading.greaterThanOrEqualTo(0)
            }
        case .scaleAspectFill: fallthrough
        case .scaleToFill: fallthrough
        case .redraw: fallthrough
        case .scaleAspectFit:
            view.snp.makeConstraints { $0.edges.equalTo(0) }
        }
    }
}

public extension Content {
    func apply(contentMode: UIView.ContentMode) {
        self.reload(contentMode: contentMode)
    }
}

public extension Content {
    class func Center(_ view: UIView) -> Content {
        return .init(view, contentMode: .center)
    }
    
    class func TopLeft(_ view: UIView) -> Content {
        return .init(view, contentMode: .topLeft)
    }
    
    class func Top(_ view: UIView) -> Content {
        return .init(view, contentMode: .top)
    }
    
    class func TopRight(_ view: UIView) -> Content {
        return .init(view, contentMode: .topRight)
    }
    
    class func Left(_ view: UIView) -> Content {
        return .init(view, contentMode: .left)
    }
    
    class func Right(_ view: UIView) -> Content {
        return .init(view, contentMode: .right)
    }
    
    class func BottomLeft(_ view: UIView) -> Content {
        return .init(view, contentMode: .bottomLeft)
    }
    
    class func Bottom(_ view: UIView) -> Content {
        return .init(view, contentMode: .bottom)
    }
    
    class func BottomRight(_ view: UIView) -> Content {
        return .init(view, contentMode: .bottomRight)
    }
}
