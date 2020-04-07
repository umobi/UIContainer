//
//  WindowProviderType.swift
//  Pods
//
//  Created by brennobemoura on 25/09/19.
//

import Foundation
import ConstraintBuilder

public protocol WindowContainerType {
    var container: UIView! { get }
    
    static func launcher(in windowContainer: WindowContainer<Self>) -> UIView!

    static var showDebugView: Bool { get }
    
}

public extension WindowContainerType {
    static var showDebugView: Bool {
        return false
    }
}

class DebugView: View {
    override func prepare() {
        super.prepare()

        let label = OneLineLabel()
        label.text = "DEBUG"
        label.textColor = .red
        label.font = UIFont.boldSystemFont(ofSize: 16.0)

        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .horizontal)

        let content = ContentView.Right(label)

        Constraintable.activate(
            label.cbuild
                .leading
        )

        AddSubview(self).addSubview(content)

        Constraintable.activate(
            content.cbuild
                .top,

            content.cbuild
                .trailing,

            content.cbuild
                .bottom
                .equalTo(self.cbuild.topMargin)
        )
    }
}
