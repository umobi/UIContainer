//
// Copyright (c) 2019-Present Umobi - https://github.com/umobi
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation
import SwiftUI

#if os(iOS) || os(tvOS)
import UIKit

public struct SUIContainerView<UIViewType>: UIViewRepresentable where UIViewType: UIView {
    private let content: () -> UIViewType

    public init(_ content: @escaping () -> UIViewType) {
        self.content = content
    }

    public func makeUIView(context: Context) -> UIViewType {
        self.content()
    }

    public func updateUIView(_ uiView: UIViewType, context: Context) {}
}

#elseif os(macOS)
import AppKit

public struct SUIContainerView<NSViewType>: NSViewRepresentable where NSViewType: NSView {

    private let content: () -> NSViewType

    public init(_ content: @escaping () -> NSViewType) {
        self.content = content
    }

    public func makeNSView(context: Context) -> NSViewType {
        self.content()
    }

    public func updateNSView(_ nsViewController: NSViewType, context: Context) {}
}
#endif
