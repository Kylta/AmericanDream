//
//  GenericItemMapper.swift
//  OCExchange
//
//  Created by Christophe Bugnon on 17/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

internal final class ExchangeItemMapper: Decodable {
    let timestamp: Int
    let base: String
    let date: String
    let rates: Rates

    var genericItem: ExchangeModel {
        return ExchangeModel(timestamp: timestamp, date: date, base: base, currency: rates.getCurrencies())
    }

    struct Rates: Decodable {
        let gbp: Double
        let cad: Double
        let aud: Double
        let jpy: Double
        let cny: Double
        let inr: Double
        let sgd: Double
        let brl: Double
        let idr: Double
        let vnd: Double
        let mxn: Double

        enum CodingKeys: String, CodingKey {
            case gbp = "GBP"
            case cad = "CAD"
            case aud = "AUD"
            case jpy = "JPY"
            case cny = "CNY"
            case inr = "INR"
            case sgd = "SGD"
            case brl = "BRL"
            case idr = "IDR"
            case vnd = "VND"
            case mxn = "MXN"
        }

        func getCurrencies() -> [String: Double] {
            return ["GBP": gbp,
                    "CAD": cad,
                    "AUD": aud,
                    "JPY": jpy,
                    "CNY": cny,
                    "INR": inr,
                    "SGD": sgd,
                    "BRL": brl,
                    "IDR": idr,
                    "VND": vnd,
                    "MXN": mxn]
        }
    }


    private static var OK_200: Int {
        return 200
    }

    internal static func map(_ data: Data, _ response: HTTPURLResponse) -> RemoteExchangeLoader.Result {
        guard response.statusCode == OK_200,
            let genericItemMapper = try? JSONDecoder().decode(ExchangeItemMapper.self, from: data) else {
                return .failure(RemoteExchangeLoader.Error.invalidData)
        }

        return .success(genericItemMapper.genericItem)
    }
}
