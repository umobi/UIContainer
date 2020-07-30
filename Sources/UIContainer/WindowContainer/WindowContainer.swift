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

public struct WindowContainer<Provider>: SwiftUI.View where Provider: RawWindowProvider {
    @ObservedObject private var settings: WindowSetting<Provider>

    private let animation: RawWindowAnimation

    public init(_ provider: Provider) {
        self.settings = .init(provider)
        self.animation = CrossFadeWindowAnimation()
    }

    private init(_ original: WindowContainer<Provider>, editable: Editable) {
        self.settings = original.settings
        self.animation = editable.animation
    }

    fileprivate func edit(_ edit: (Editable) -> Void) -> Self {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }

    public var body: some SwiftUI.View {
        self.animation
            .animate(self.settings.provider.view)
            .environmentObject(self.settings)
    }
}

public extension WindowContainer {
    func animation(_ animation: RawWindowAnimation) -> Self {
        self.edit {
            $0.animation = animation
        }
    }
}

fileprivate extension WindowContainer {
    class Editable {
        var animation: RawWindowAnimation

        init(_ original: WindowContainer<Provider>) {
            self.animation = original.animation
        }
    }
}
