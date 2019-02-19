//
//  Service+Helper.swift
//  OCTranslateAPI
//
//  Created by Christophe Bugnon on 19/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

extension JSONDecoder {
    func decode<T: Decodable>(_ type: T.Type, withJSONObject object: Any, options opt: JSONSerialization.WritingOptions = []) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: object, options: opt)
        return try decode(T.self, from: data)
    }
}
