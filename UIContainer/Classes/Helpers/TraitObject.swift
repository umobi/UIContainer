//
//  TraitObject.swift
//  UIContainer
//
//  Created by brennobemoura on 30/10/19.
//

import Foundation
import UIKit

public class TraitObject<T> {
    private let dynamic: (UITraitCollection) -> T

    public init(dynamic: @escaping (UITraitCollection) -> T) {
        self.dynamic = dynamic
    }

    public func onTrait(_ trait: UITraitCollection) -> T {
        return self.dynamic(trait)
    }
}
