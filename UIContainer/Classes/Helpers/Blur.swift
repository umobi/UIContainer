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

private var kVibrancyEffectStyle: UInt = 0

@available(iOS 13, *)
public extension BlurView {
    fileprivate(set) var vibrancyEffect: TraitObject<UIVibrancyEffectStyle> {
        get { return objc_getAssociatedObject(self, &kVibrancyEffectStyle) as! TraitObject<UIVibrancyEffectStyle> }
        set { objc_setAssociatedObject(self, &kVibrancyEffectStyle, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
}

open class BlurView: View {
    
    private(set) var blurEffect: TraitObject<UIBlurEffect.Style>

    weak var blurView: UIVisualEffectView!
    
    public convenience init(blur: UIBlurEffect.Style) {
        if #available(iOS 13, *) {
            self.init(dynamicBlur: .init(dynamic: { _ in blur }), dynamicVibrancy: .init(dynamic: { _ in .fill }))
        } else {
            self.init(dynamicBlur: .init(dynamic: { _ in blur }))
        }
    }

    @available(iOS 13, *)
    public convenience init(blur: UIBlurEffect.Style, vibrancy: UIVibrancyEffectStyle) {
        self.init(dynamicBlur: .init(dynamic: { _ in blur }), dynamicVibrancy: .init(dynamic: { _ in vibrancy }))
    }

    public init(dynamicBlur: TraitObject<UIBlurEffect.Style>) {
        self.blurEffect = dynamicBlur
        super.init(frame: .zero)

        if #available(iOS 13, *) {
            self.vibrancyEffect = .init(dynamic: { _ in .fill })
        }

        self.blurView = self.createEffect()
    }

    @available(iOS 13, *)
    public init(dynamicBlur: TraitObject<UIBlurEffect.Style>, dynamicVibrancy: TraitObject<UIVibrancyEffectStyle>) {
        self.blurEffect = dynamicBlur
        super.init(frame: .zero)
        self.vibrancyEffect = dynamicVibrancy

        self.blurView = self.createEffect()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createEffect() -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: self.blurEffect.onTrait(self.traitCollection))
        let blurEffectView = UIVisualEffectView(effect: blurEffect)

        let vibrancyEffect: UIVibrancyEffect = {
            guard #available(iOS 13, *) else {
                return UIVibrancyEffect(blurEffect: blurEffect)
            }

            return .init(blurEffect: blurEffect, style: self.vibrancyEffect.onTrait(self.traitCollection))
        }()
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

    @available(iOS 13, *)
    private func reload(_ vibrancyEffect: UIVibrancyEffectStyle) {
        self.reload(.init(dynamic: { _ in vibrancyEffect }))
    }

    private func reload(_ dynamicBlur: TraitObject<UIBlurEffect.Style>) {
        self.blurEffect = dynamicBlur
        self.reload()
    }

    @available(iOS 13, *)
    private func reload(_ dynamicVibrancy: TraitObject<UIVibrancyEffectStyle>) {
        self.vibrancyEffect = dynamicVibrancy
        self.reload()
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.reload()
    }
}

public extension BlurView {
    func apply(blurEffect: UIBlurEffect.Style) {
        self.reload(blurEffect)
    }

    func apply(dynamicBlur: TraitObject<UIBlurEffect.Style>) {
        self.reload(dynamicBlur)
    }
}

@available(iOS 13, *)
public extension BlurView {
    func apply(vibrancyEffect: UIVibrancyEffectStyle) {
        self.reload(vibrancyEffect)
    }

    func apply(dynamicVibrancy: TraitObject<UIVibrancyEffectStyle>) {
        self.reload(dynamicVibrancy)
    }
}
