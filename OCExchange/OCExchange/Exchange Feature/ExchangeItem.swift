//
//  ExchangeItem.swift
//  OCExchange
//
//  Created by Christophe Bugnon on 17/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

public struct ExchangeModel: Equatable {
    public typealias Currency = [String: Double]
    public let timestamp: Int
    public let date: String
    public let base: String
    public let currency: Currency

    public init(timestamp: Int, date: String, base: String, currency: Currency) {
        self.timestamp = timestamp
        self.date = date
        self.base = base
        self.currency = currency
    }
}
