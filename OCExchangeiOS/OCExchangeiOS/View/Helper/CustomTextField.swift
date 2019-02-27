//
//  CustomLabel.swift
//  OCExchangeiOS
//
//  Created by Christophe Bugnon on 25/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
