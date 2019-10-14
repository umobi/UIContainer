//
//  Dashed.swift
//  Fujioka
//
//  Created by brennobemoura on 09/10/19.
//  Copyright © 2019 Umobi. All rights reserved.
//

import Foundation
import UIKit
import UIContainer
import SnapKit

public class Blur: UIView {
    
    private(set) var blurEffect: UIBlurEffect.Style
    weak var blurView: UIVisualEffectView!
    
    public init(blur: UIBlurEffect.Style) {
        self.blurEffect = blur
        super.init(frame: .zero)
        
        self.blurView = self.createEffect()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createEffect() -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: self.blurEffect)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)

        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)

        blurEffectView.contentView.addSubview(vibrancyEffectView)

        vibrancyEffectView.snp.makeConstraints { make in
            make.top.bottom.trailing.leading.equalTo(0)
        }

        self.addSubview(blurEffectView)
        blurEffectView.snp.makeConstraints { $0.edges.equalTo(0) }
        
        return blurEffectView
    }
    
    private func reload(_ blurEffect: UIBlurEffect.Style) {
        guard self.blurEffect != blurEffect else {
            return
        }
        
        self.blurView?.removeFromSuperview()
        guard let view = self.subviews.first else {
            return
        }
        
        view.removeFromSuperview()
        self.blurEffect = blurEffect
        self.blurView = self.createEffect()
    }
}

public extension Blur {
    func apply(blurEffect: UIBlurEffect.Style) {
        self.reload(blurEffect)
    }
}
