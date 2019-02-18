//
//  GenericAPIEndToEndTests.swift
//  GenericAPIEndToEndTests
//
//  Created by Christophe Bugnon on 17/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import XCTest
import GenericAPI

class GenericAPIEndToEndTests: XCTestCase {

    func test_endToEndTestServerGETWeatherResult_matchesFixedTestAccountData() {
        switch getWeatherResult() {
        case let .success(item)?:
            XCTAssertNotNil(item)
        case let .failure(error)?:
            XCTFail("Expected successful weather result, got \(error) instead")
        default:
            XCTFail("Expected successful weather result, got no result instead")
        }
    }

    // MARK: - Helpers

    private func getWeatherResult(file: StaticString = #file, line: UInt = #line) -> LoadGenericResult<GenericModel>? {
        let client = URLSessionHTTPClient()
        // Use samples URL from your API
        let testServerURL = URL(string: "https://samples.openweathermap.org/data/2.5/weather?q=London,uk&appid=b6907d289e10d714a6e88b30761fae22")!
        let loader = RemoteGenericLoader(client: client, url: testServerURL)
        trackMemoryLeaks(instance: client, file: file, line: line)
        trackMemoryLeaks(instance: loader, file: file, line: line)

        let exp = expectation(description: "Wait for load completion")

        var receivedResult: LoadGenericResult<GenericModel>?
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }

        wait(for: [exp], timeout: 5.0)
        return receivedResult
    }
}
