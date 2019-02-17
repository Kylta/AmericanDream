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

        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_loadTwice_requestDataFromURLTwice() {
        let url = URL(string: "http://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }
        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()

        expect(sut: sut, toCompleteWithResult: .failure(.connectivity), when: {
            let clientError = NSError(domain: "test", code: 0)
            client.complete(with: clientError)
        })
    }

    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]

        samples.enumerated().forEach { index, code in
            expect(sut: sut, toCompleteWithResult: .failure(.invalidData), when: {
                let invalidJSON = Data(bytes: "invalid json".utf8)
                client.complete(withStatusCode: code, data: invalidJSON, at: index)
            })
        }
    }

    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()

        expect(sut: sut, toCompleteWithResult: .failure(.invalidData), when: {
            let invalidJSON = Data(bytes: "invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }

    func test_load_deliversItemOn200HTTPResponseWithJSONItem() {
        let (sut, client) = makeSUT()

        let item = makeItem(name: "a name", date: "02-16-2019 19:00", weather: "a weather", description: "a description", temperature: 2.0, wind: 3.0)

        expect(sut: sut, toCompleteWithResult: .success(item.model), when: {
            client.complete(withStatusCode: 200, data: item.json)
        })
    }

    // MARK: - Helpers

    private func makeSUT(url: URL = URL(string: "http://a-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteWeatherLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteWeatherLoader(client: client, url: url)

        trackMemoryLeaks(instance: client, file: file, line: line)
        trackMemoryLeaks(instance: sut, file: file, line: line)

        return (sut, client)
    }

    fileprivate func trackMemoryLeaks(instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }

    fileprivate func makeItem(name: String, date: String, weather: String, description: String, temperature: Double, wind: Double) -> (model: WeatherItem, json: Data) {
        let item = WeatherItem(name: name, date: date, weather: weather, description: description, temperature: temperature, wind: wind)
        let filePath = Bundle(for: type(of: self)).url(forResource: "weather", withExtension: "json")!
        let json = try! Data(contentsOf: filePath)

        return (item, json)
    }

    private func expect(sut: RemoteWeatherLoader, toCompleteWithResult result: RemoteWeatherLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        var capturedResults = [RemoteWeatherLoader.Result]()
        sut.load { capturedResults.append($0) }

        action()

        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }

    class HTTPClientSpy: HTTPClient {
        var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()

        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }

        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }

        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }

        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil)!

            messages[index].completion(.success(data, response))
        }
    }
}
