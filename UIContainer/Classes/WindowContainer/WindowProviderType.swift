//
//  WindowProviderType.swift
//  Pods
//
//  Created by brennobemoura on 25/09/19.
//

import Foundation

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

        let content = Content.Right(label)
        label.snp.makeConstraints {
            $0.leading.equalTo(0)
        }

        self.addSubview(content)
        content.snp.makeConstraints {
            $0.top.trailing.equalTo(0)
            $0.bottom.equalTo(self.snp.topMargin)
        }
    }
}
