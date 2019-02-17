//
//  RemoteWeatherLoaderTests.swift
//  OCWeatherTests
//
//  Created by Christophe Bugnon on 17/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import XCTest
import OCWeather

class RemoteWeatherLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_load_requestDataFromURL() {
        let url = URL(string: "http://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load()

        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_loadTwice_requestDataFromURLTwice() {
        let url = URL(string: "http://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load()
        sut.load()

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        client.error = NSError(domain: "test", code: 0)

        var capturedError = [RemoteWeatherLoader.Error]()
        sut.load { capturedError.append($0)}

        XCTAssertEqual(capturedError, [.connectivity])
    }

    // MARK: - Helpers

    private func makeSUT(url: URL = URL(string: "http://a-url.com")!) -> (sut: RemoteWeatherLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteWeatherLoader(client: client, url: url)
        return (sut, client)
    }

    class HTTPClientSpy: HTTPClient {
        var requestedURLs = [URL]()
        var error: NSError?

        func get(from url: URL, completion: (Error) -> Void) {
            if let error = error {
                completion(error)
            }
            requestedURLs.append(url)
        }
    }
}
