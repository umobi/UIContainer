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
import UIKit
import ConstraintBuilder

public protocol ContainerCellRepresentable: ContainerRepresentable where ContainerCell.View == View {
    associatedtype ContainerCell: ContainerRepresentable
    var containerView: ContainerCell! { get set }
    
    func addCell(_ containerCell: ContainerCell)
    
    //func containerDidLoad()
    func spacer<T: UIView>(_ view: T) -> SpacerView
}

public extension ContainerCellRepresentable {
    weak var view: ContainerCell.View! {
        get {
            return self.containerView.view
        }
        
        set {
            self.containerView.view = newValue
        }
    }
    
    func removeContainer() {
        fatalError("Don't try to remove ContainerCell")
    }
    
    func insertContainer(view: View!) {
        fatalError("Don't try to insert in ContainerCell")
    }
    
    weak var parent: ParentView! {
        get {
            return self.containerView.parent
        }
        
        set {
            fatalError("Setting parent for UIContainerCell should never happen")
        }
    }
}

public extension ContainerCellRepresentable where Self: UICollectionViewCell, ContainerCell: UIView {
    func addCell(_ containerCell: ContainerCell) {
        let spacer = self.spacer(containerCell)
        AddSubview(self.contentView).addSubview(spacer)

        Constraintable.activate(
            spacer.cbuild
                .edges
        )
    }
}

public extension ContainerCellRepresentable where Self: UITableViewCell, ContainerCell: UIView {
    func addCell(_ containerCell: ContainerCell) {
        let spacer = self.spacer(containerCell)
        AddSubview(self.contentView).addSubview(spacer)

        Constraintable.activate(
            spacer.cbuild
                .edges
        )
    }
}

public extension ContainerCellRepresentable where View: ContainerCellDelegate {
    func prepareContainer(inside parentView: ParentView!, loadHandler: (() -> View?)? = nil) {
        if self.containerView != nil {
            return
        }
        
        let containerView = ContainerCell(in: parentView, loadHandler: loadHandler)
        containerView.view.cellDelegate = parentView as? ContainerCell.View.Delegate
        
        self.containerView = containerView
        self.addCell(containerView)
        
        self.containerDidLoad()
    }
}
