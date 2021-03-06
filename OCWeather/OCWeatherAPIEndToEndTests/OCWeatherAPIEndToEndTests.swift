//
//  OCWeatherAPIEndToEndTests.swift
//  OCWeatherAPIEndToEndTests
//
//  Created by Christophe Bugnon on 17/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import XCTest
import OCWeather

class OCWeatherAPIEndToEndTests: XCTestCase {

    func test_endToEndTestServerGETWeatherResult_matchesFixedTestAccountData() {
        switch getWeatherResult() {
        case let .success(item)?:
            XCTAssertEqual(item.name, "London")
            XCTAssertEqual(item.temperature, 280.32)
            XCTAssertEqual(item.date, 1485789600)
            XCTAssertEqual(item.wind, 4.1)
            XCTAssertEqual(item.weather, "Drizzle")
            XCTAssertEqual(item.description, "light intensity drizzle")
        case let .failure(error)?:
            XCTFail("Expected successful weather result, got \(error) instead")
        default:
            XCTFail("Expected successful weather result, got no result instead")
        }
    }

    // MARK: - Helpers

    private func getWeatherResult(file: StaticString = #file, line: UInt = #line) -> LoadWeatherResult? {
        let client = URLSessionHTTPClient()
        let testServerURL = URL(string: "https://samples.openweathermap.org/data/2.5/weather?q=London,uk&appid=b6907d289e10d714a6e88b30761fae22")!
        let loader = RemoteWeatherLoader(client: client, url: testServerURL)
        trackMemoryLeaks(instance: client, file: file, line: line)
        trackMemoryLeaks(instance: loader, file: file, line: line)

        let exp = expectation(description: "Wait for load completion")

        var receivedResult: LoadWeatherResult?
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }

        wait(for: [exp], timeout: 5.0)
        return receivedResult
    }
}
