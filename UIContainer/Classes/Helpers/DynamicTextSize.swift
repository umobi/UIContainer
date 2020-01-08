//
//  UILabel+TextStyle.swift
//  TokBeauty
//
//  Created by brennobemoura on 06/11/19.
//  Copyright © 2019 TokBeauty. All rights reserved.
//

import Foundation
import UIKit

public class DynamicTextSize: UIView {
    private weak var label: UILabel!
    fileprivate var textValueObserver: NSKeyValueObservation!
    fileprivate var numberOfLinesObserver: NSKeyValueObservation!
    fileprivate var hyphenFactor: CGFloat = 0

    private var limitContentSize: UIContentSizeCategory?

    public var overrideMinimumScaleFactor: CGFloat?
    public var overrideAdjustsFontSizeToFitWidth: Bool?

    var isMultilineText: Bool {
        return self.label?.numberOfLines ?? 1 != 1
    }

    private init(_ label: UILabel) {
        super.init(frame: .zero)

        self.label = label
        self.label.adjustsFontForContentSizeCategory = true
        label.addSubview(self)
        self.snp.makeConstraints {
            $0.edges.equalTo(0)
        }

        self.prepare()
    }

    private func prepare() {
        self.numberOfLinesObserver = self.label.observe(\.numberOfLines) { [weak self] (_, _) in
            self?.textDidChange()
        }

        self.textValueObserver = self.label.observe(\.text) { [weak self] (_, _) in
            self?.textDidChange()
        }
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.preferredContentSizeCategory != self.traitCollection.preferredContentSizeCategory {
            self.textDidChange()
        }
    }

    private func textDidChange() {
        guard self.isMultilineText else {
            self.asOneLineText()
            return
        }

        self.asMultilineText()
    }

    private func asOneLineText() {
        self.label?.minimumScaleFactor = self.overrideMinimumScaleFactor ?? 0.0
        self.label?.adjustsFontSizeToFitWidth = self.overrideAdjustsFontSizeToFitWidth ?? true
    }

    private func asMultilineText() {
        let needToUpdate: Bool = {
            if #available(iOS 11.0, tvOS 11.0, *) {
                return self.traitCollection.preferredContentSizeCategory >= (self.limitContentSize ?? self.traitCollection.preferredContentSizeCategory)
            }

            let comparationResult = [UIContentSizeCategory]([.unspecified, .extraSmall, .small, .medium, .large, .extraLarge, .extraExtraLarge, .extraExtraExtraLarge, .accessibilityMedium, .accessibilityLarge, .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge]).reduce((false, false)) {
                let isGratherOrEqualToLimitsSize = $0.1 || $1 == (self.limitContentSize ?? self.traitCollection.preferredContentSizeCategory)

                return ($0.0 || (isGratherOrEqualToLimitsSize && $1 == self.traitCollection.preferredContentSizeCategory), isGratherOrEqualToLimitsSize)
                }

            return comparationResult.1 && comparationResult.0
        }()

        if needToUpdate {
            self.label?.hyphenate(factor: Float(self.hyphenFactor))
        } else {
            self.label?.removeHyphen()
        }
    }

    public func setLimitContentSize(category contentSizeCategory: UIContentSizeCategory) {
        self.limitContentSize = contentSizeCategory
        self.textDidChange()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate static func orEmpty(in label: UILabel) -> DynamicTextSize? {
        return label.subviews.first(where: { $0 is DynamicTextSize }) as? DynamicTextSize
    }

    fileprivate static func orCreate(in label: UILabel) -> DynamicTextSize {
        return self.orEmpty(in: label) ?? DynamicTextSize(label)
    }

    override public func removeFromSuperview() {
        super.removeFromSuperview()
        self.label?.adjustsFontForContentSizeCategory = false
    }
}

public class Label: UILabel {
    deinit {
        if #available(iOS 11, *) {
            return
        }

        guard let textObserver = self.dynamicText?.textValueObserver else {
            return
        }

        self.removeObserver(textObserver, forKeyPath: "text")

        guard let numberOfLinesObserver = self.dynamicText?.numberOfLinesObserver else {
            return
        }

        self.removeObserver(numberOfLinesObserver, forKeyPath: "numberOfLines")
    }
}

public extension UILabel {
    @IBInspectable var isDynamicTextSize: Bool {
        get { return DynamicTextSize.orEmpty(in: self) != nil }
        set {
            guard newValue else {
                DynamicTextSize.orEmpty(in: self)?.removeFromSuperview()
                return
            }

            _ = DynamicTextSize.orCreate(in: self)
        }
    }

    @IBInspectable var hyphenFactor: CGFloat {
        get { return self.dynamicText?.hyphenFactor ?? 0 }
        set {
            DynamicTextSize.orCreate(in: self).hyphenFactor = newValue
        }
    }

    var dynamicText: DynamicTextSize? {
        return .orEmpty(in: self)
    }
}

public extension UILabel {
    public class OneLine: Label {
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.prepare()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            self.prepare()
        }

        init() {
            super.init(frame: .zero)
            self.prepare()
        }

        func prepare() {
            self.isDynamicTextSize = true
            self.numberOfLines = 1
            self.minimumScaleFactor = 0
            self.adjustsFontSizeToFitWidth = true
        }
    }
}

public extension UILabel {
    public class Multiline: Label {
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.prepare()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            self.prepare()
        }

        init() {
            super.init(frame: .zero)
            self.prepare()
        }

        func prepare() {
            self.isDynamicTextSize = true
            self.numberOfLines = 0
            self.hyphenFactor = 0.3
        }
    }
}

private extension UILabel {
    func hyphenate(factor: Float = 1.0) {
        let paragraphStyle = NSMutableParagraphStyle()
        let attstr: NSMutableAttributedString = {
            if let attributedText = self.attributedText {
                return NSMutableAttributedString(attributedString: attributedText)
            }

            return NSMutableAttributedString(string: self.text ?? "")
        }()

        paragraphStyle.hyphenationFactor = factor
        attstr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(0..<attstr.length))
        self.attributedText = attstr
    }

    func removeHyphen() {
        let paragraphStyle = NSMutableParagraphStyle()
        let attstr = NSMutableAttributedString(attributedString: self.attributedText!)
        paragraphStyle.hyphenationFactor = 0
        attstr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(0..<attstr.length))
        self.attributedText = attstr
    }
}

public class OneLineLabel: UILabel.OneLine {}
public class HyphenateLabel: UILabel.Multiline {}
