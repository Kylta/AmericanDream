//
//  TranslateItemMapper.swift
//  OCTranslate
//
//  Created by Christophe Bugnon on 17/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

internal final class TranslateItemMapper: Codable {

    var TranslateItem: TranslateModel {
        return TranslateModel()
    }

    private static var OK_200: Int {
        return 200
    }

    internal static func map(_ data: Data, _ response: HTTPURLResponse) -> RemoteTranslateLoader.Result {
        guard response.statusCode == OK_200,
            let TranslateItemMapper = try? JSONDecoder().decode(TranslateItemMapper.self, from: data) else {
                return .failure(RemoteTranslateLoader.Error.invalidData)
        }

        return .success(TranslateItemMapper.TranslateItem)
    }
}
