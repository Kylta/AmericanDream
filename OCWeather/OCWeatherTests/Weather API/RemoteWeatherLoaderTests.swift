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
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_loadTwice_requestDataFromURLTwice() {
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }
        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()

        expect(sut: sut, toCompleteWith: failure(.connectivity), when: {
            let clientError = NSError(domain: "test", code: 0)
            client.complete(with: clientError)
        })
    }

    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]

        samples.enumerated().forEach { index, code in
            expect(sut: sut, toCompleteWith: failure(.invalidData), when: {
                let invalidJSON = makeJSON(valid: false)
                client.complete(withStatusCode: code, data: invalidJSON, at: index)
            })
        }
    }

    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()

        expect(sut: sut, toCompleteWith: failure(.invalidData), when: {
            let invalidJSON = makeJSON(valid: false)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }

    func test_load_deliversItemOn200HTTPResponseWithJSONItem() {
        let (sut, client) = makeSUT()

        let item = makeItem(name: "a name", date: 1550340000, weather: "a weather", description: "a description", temperature: 2.0, wind: 3.0)

        expect(sut: sut, toCompleteWith: .success(item.model), when: {
            client.complete(withStatusCode: 200, data: makeJSON(valid: true))
        })
    }

    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let client = HTTPClientSpy()
        var sut: RemoteWeatherLoader? = RemoteWeatherLoader(client: client, url: anyURL())

        var capturedResults = [RemoteWeatherLoader.Result]()
        sut?.load { capturedResults.append($0) }

        sut = nil
        let invalidJSON = makeJSON(valid: false)
        client.complete(withStatusCode: 200, data: invalidJSON)

        XCTAssertTrue(capturedResults.isEmpty)
    }

    // MARK: - Helpers

    private func makeSUT(url: URL = URL(string: "http://a-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteWeatherLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteWeatherLoader(client: client, url: url)

        trackMemoryLeaks(instance: client, file: file, line: line)
        trackMemoryLeaks(instance: sut, file: file, line: line)

        return (sut, client)
    }

    fileprivate func failure(_ error: RemoteWeatherLoader.Error) -> RemoteWeatherLoader.Result {
        return .failure(error)
    }

    fileprivate func makeItem(name: String, date: Int, weather: String, description: String, temperature: Double, wind: Double) -> (model: WeatherItem, json: Data) {
        let item = WeatherItem(name: name, date: date, weather: weather, description: description, temperature: temperature, wind: wind)
        let json = makeJSON(valid: true)

        return (item, json)
    }

    fileprivate func makeJSON(valid: Bool) -> Data {
        let invalidJSON = Data(bytes: "invalid json".utf8)
        let json = """
        {
            "name": "a name",
            "dt": 1550340000,
            "weather": [{
                "main": "a weather",
                "description": "a description"
            }],
            "wind": {
                "speed": 3.0
            },
            "main": {
                "temp": 2.0
            }
        }
"""
        let jsonString = json.data(using: .utf8)!
        let jsonData = try! JSONSerialization.jsonObject(with: jsonString, options: []) as! [String: Any]
        let validJSON = try! JSONSerialization.data(withJSONObject: jsonData)

        return valid ? validJSON : invalidJSON
    }

    fileprivate func anyURL() -> URL {
        return URL(string: "https://any-url.com")!
    }

    private func expect(sut: RemoteWeatherLoader, toCompleteWith expectedResult: RemoteWeatherLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {

        let exp = expectation(description: "Wait for completion")

        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItem), .success(expectedItem)):
                XCTAssertEqual(receivedItem, expectedItem, file: file, line: line)
            case let (.failure(receivedError as RemoteWeatherLoader.Error), .failure(expectedError as RemoteWeatherLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }

        action()
        wait(for: [exp], timeout: 1.0)
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
