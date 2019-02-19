//
//  Service.swift
//  OCTranslateAPI
//
//  Created by Christophe Bugnon on 19/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

struct Service {
    static func getJSON(from data: Data, atKeyPath keyPath: String) throws -> Any {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
            let result = json?[keyPath] else {
                throw RemoteTranslateLoader.Error.invalidData
        }
        return result
    }
}
