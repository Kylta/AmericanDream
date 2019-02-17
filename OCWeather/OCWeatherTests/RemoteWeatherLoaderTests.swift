//
//  RemoteWeatherLoaderTests.swift
//  OCWeatherTests
//
//  Created by Christophe Bugnon on 17/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import XCTest

class RemoteWeatherLoader {
    let client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
    }
}

protocol HTTPClient {
    func get(from url: URL)
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?

    func get(from url: URL) {
        requestedURL = url
    }
}

class RemoteWeatherLoaderTests: XCTestCase {

    func test_init() {
        let client = HTTPClientSpy()
        _ = RemoteWeatherLoader(client: client)

        XCTAssertNil(client.requestedURL)
    }
}
