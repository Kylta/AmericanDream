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
        let client = URLSessionHTTPClient()
        let testServerURL = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=Paris,fr&units=metric&APPID=f33ca45f1e944339541f316aef6cda60")!
        let loader = RemoteWeatherLoader(client: client, url: testServerURL)

        let exp = expectation(description: "Wait for load completion")

        var receivedResult: LoadWeatherResult?
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }

        wait(for: [exp], timeout: 5.0)

        switch receivedResult {
        case let .success(item)?:
            XCTAssertEqual(item.name, "Paris")
        case let .failure(error)?:
            XCTFail("Expected successful weather result, got \(error) instead")
        default:
            XCTFail("Expected successful weather result, got no result instead")
        }
    }
}
