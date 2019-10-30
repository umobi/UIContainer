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

public class Blur: UIView {
    
    private(set) var blurEffect: TraitObject<UIBlurEffect.Style>
    weak var blurView: UIVisualEffectView!
    
    public convenience init(blur: UIBlurEffect.Style) {
        self.init(dynamicBlur: .init(dynamic: { _ in blur }))
    }

    public init(dynamicBlur: TraitObject<UIBlurEffect.Style>) {
        self.blurEffect = dynamicBlur
        super.init(frame: .zero)

        self.blurView = self.createEffect()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createEffect() -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: self.blurEffect.onTrait(self.traitCollection))
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

    private func reload() {
        self.subviews.forEach { $0.removeFromSuperview() }
        self.blurView = self.createEffect()
    }

    private func reload(_ blurEffect: UIBlurEffect.Style) {
        self.reload(.init(dynamic: {_ in blurEffect }))
    }

    private func reload(_ dynamicBlur: TraitObject<UIBlurEffect.Style>) {
        self.blurEffect = dynamicBlur
        self.reload()
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.reload()
    }
}

public extension Blur {
    func apply(blurEffect: UIBlurEffect.Style) {
        self.reload(blurEffect)
    }

    func apply(dynamicBlur: TraitObject<UIBlurEffect.Style>) {
        self.reload(dynamicBlur)
    }
}
