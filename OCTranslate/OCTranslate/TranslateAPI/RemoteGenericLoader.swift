//
//  RemoteTranslateLoader.swift
//  OCTranslate
//
//  Created by Christophe Bugnon on 17/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

public final class RemoteTranslateLoader: TranslateLoader {
    private let client: HTTPClient
    private let url: URL

    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public typealias Result = LoadTranslateResult<TranslateModel>

    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success(data, response):
                completion(TranslateItemMapper.map(data, response))
            case .failure:
                completion(.failure(RemoteTranslateLoader.Error.connectivity))
            }
        }
    }
}
