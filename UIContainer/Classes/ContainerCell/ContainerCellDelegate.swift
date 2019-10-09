//
//  ContainerCellDelegate.swift
//  mercadoon
//
//  Created by brennobemoura on 06/09/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation

public protocol ContainerCellDelegate {
    associatedtype Delegate
    var cellDelegate: Delegate? { get set }
}

public extension ContainerCellDelegate where Delegate == EmptyCellDelegate {
    var cellDelegate: Delegate? {
        get {
            return nil
        }
        
        set {
            guard newValue != nil else { return }
            print("[\(String(describing: Self.self))] don't set cellDelegate when it constraints to EmptyCellDelegate")
        }
    }
}

public protocol EmptyCellDelegate {}

public protocol OptionalCellDelegate {}
