//
//  BaseView.swift
//  TokBeauty
//
//  Created by brennobemoura on 18/04/19.
//  Copyright © 2019 TokBeauty. All rights reserved.
//

import UIKit
import ConstraintBuilder

open class NibView: View {
    @IBOutlet public weak var view: UIView!

    open var className: String {
        return String(describing: type(of: self))
    }
    
    open override func prepare() {
        super.prepare()
        self.loadFromNib()
    }
    
    private func loadFromNib() {
        Bundle(for: type(of: self)).loadNibNamed("\(self.className)", owner: self, options: nil)

        AddSubview(self).addSubview(view)

        Constraintable.activate(
            view.cbuild
                .edges
        )
    }
}
