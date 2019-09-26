//
//  ViewSharedContext.swift
//  Pods-UIContainer_Tests
//
//  Created by brennobemoura on 25/09/19.
//

import Foundation

public protocol ViewSharedContext {
    static var __shared: Self? { get set }
    static var shared: Self { get }
    
    static func loadView() -> Self
}

public extension ViewSharedContext {
    static var shared: Self {
        let shared = self.__shared ?? self.loadView()
        self.__shared = shared
        return shared
    }
}
