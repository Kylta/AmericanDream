//
//  CustomLabel.swift
//  OCExchangeiOS
//
//  Created by Christophe Bugnon on 25/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 0)
        super.drawText(in: rect.inset(by: insets))
    }
}
