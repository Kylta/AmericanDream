//
//  TranslateItemMapper.swift
//  OCTranslate
//
//  Created by Christophe Bugnon on 17/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

internal final class TranslateItemMapper: Decodable {
    let translations: [Response]
    var translateItem: TranslateModel {
        return TranslateModel(translatedText: translations.map { $0.translatedText }.first!)
    }

    struct Response: Decodable {
        let detectedSourceLanguage: String
        let translatedText: String
    }

    private static var OK_200: Int {
        return 200
    }

    internal static func map(_ data: Data, _ response: HTTPURLResponse) -> RemoteTranslateLoader.Result {
        guard response.statusCode == OK_200,
            let json = try? Service.getJSON(from: data, atKeyPath: "data"),
            let translateItemMapper = try? JSONDecoder().decode(TranslateItemMapper.self, withJSONObject: json) else {
                return .failure(RemoteTranslateLoader.Error.invalidData)
        }

        return .success(translateItemMapper.translateItem)
    }
}
