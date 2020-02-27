//
//  Dashed.swift
//  Fujioka
//
//  Created by brennobemoura on 09/10/19.
//  Copyright © 2019 Umobi. All rights reserved.
//

import Foundation
import UIKit
import EasyAnchor

private var kVibrancyEffectStyle: UInt = 0

#if os(iOS)
@available(iOS 13, *)
public extension BlurView {
    fileprivate(set) var vibrancyEffect: TraitObject<UIVibrancyEffectStyle> {
        get { return objc_getAssociatedObject(self, &kVibrancyEffectStyle) as! TraitObject<UIVibrancyEffectStyle> }
        set { objc_setAssociatedObject(self, &kVibrancyEffectStyle, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
}
#endif

open class BlurView: View {
    
    private(set) var blurEffect: TraitObject<UIBlurEffect.Style>

    weak var blurView: UIVisualEffectView!
    
    public convenience init(blur: UIBlurEffect.Style) {
        #if os(iOS)
        if #available(iOS 13, *) {
            self.init(dynamicBlur: .init(dynamic: { _ in blur }), dynamicVibrancy: .init(dynamic: { _ in .fill }))
            return
        }
        #endif

        self.init(dynamicBlur: .init(dynamic: { _ in blur }))
    }

    #if os(iOS)
    @available(iOS 13, *)
    public convenience init(blur: UIBlurEffect.Style, vibrancy: UIVibrancyEffectStyle) {
        self.init(dynamicBlur: .init(dynamic: { _ in blur }), dynamicVibrancy: .init(dynamic: { _ in vibrancy }))
    }
    #endif

    public init(dynamicBlur: TraitObject<UIBlurEffect.Style>) {
        self.blurEffect = dynamicBlur
        super.init(frame: .zero)

        #if os(iOS)
        if #available(iOS 13, *) {
            self.vibrancyEffect = .init(dynamic: { _ in .fill })
        }
        #endif

        self.blurView = self.createEffect()
    }

    #if os(iOS)
    @available(iOS 13, *)
    public init(dynamicBlur: TraitObject<UIBlurEffect.Style>, dynamicVibrancy: TraitObject<UIVibrancyEffectStyle>) {
        self.blurEffect = dynamicBlur
        super.init(frame: .zero)
        self.vibrancyEffect = dynamicVibrancy

        self.blurView = self.createEffect()
    }
    #endif

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createEffect() -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: self.blurEffect.onTrait(self.traitCollection))
        let blurEffectView = UIVisualEffectView(effect: blurEffect)

        let vibrancyEffect: UIVibrancyEffect = {
            #if os(iOS)
            guard #available(iOS 13, *) else {
                return UIVibrancyEffect(blurEffect: blurEffect)
            }

            return .init(blurEffect: blurEffect, style: self.vibrancyEffect.onTrait(self.traitCollection))
            #else
            return UIVibrancyEffect(blurEffect: blurEffect)
            #endif
        }()
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)

        AddSubview(blurEffectView.contentView).addSubview(vibrancyEffectView)
        vibrancyEffectView.translatesAutoresizingMaskIntoConstraints = false

        activate(
            vibrancyEffectView.anchor
                .edges
        )

        AddSubview(self).addSubview(blurEffectView)

        activate(
            blurEffectView.anchor
                .edges
        )
        
        return blurEffectView
    }

    private func reload() {
        self.subviews.forEach { $0.removeFromSuperview() }
        self.blurView = self.createEffect()
    }

    private func reload(_ blurEffect: UIBlurEffect.Style) {
        self.reload(.init(dynamic: {_ in blurEffect }))
    }

    #if os(iOS)
    @available(iOS 13, *)
    private func reload(_ vibrancyEffect: UIVibrancyEffectStyle) {
        self.reload(.init(dynamic: { _ in vibrancyEffect }))
    }

    @available(iOS 13, *)
    private func reload(_ dynamicVibrancy: TraitObject<UIVibrancyEffectStyle>) {
        self.vibrancyEffect = dynamicVibrancy
        self.reload()
    }
    #endif

    private func reload(_ dynamicBlur: TraitObject<UIBlurEffect.Style>) {
        self.blurEffect = dynamicBlur
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

#if os(iOS)
@available(iOS 13, *)
public extension BlurView {
    func apply(vibrancyEffect: UIVibrancyEffectStyle) {
        self.reload(vibrancyEffect)
    }

    func apply(dynamicVibrancy: TraitObject<UIVibrancyEffectStyle>) {
        self.reload(dynamicVibrancy)
    }
}
#endif
