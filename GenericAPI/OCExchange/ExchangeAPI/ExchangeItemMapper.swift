//
//  GenericItemMapper.swift
//  OCExchange
//
//  Created by Christophe Bugnon on 17/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

internal final class ExchangeItemMapper: Codable {

    var genericItem: GenericModel {
        return GenericModel()
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
