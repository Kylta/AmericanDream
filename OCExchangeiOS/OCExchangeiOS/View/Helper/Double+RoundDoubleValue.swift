//
//  RoundDoubleValue.swift
//  OCExchangeiOS
//
//  Created by Christophe Bugnon on 26/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
