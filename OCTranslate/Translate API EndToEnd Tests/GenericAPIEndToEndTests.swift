//
//  TranslateAPIEndToEndTests.swift
//  TranslateAPIEndToEndTests
//
//  Created by Christophe Bugnon on 17/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import XCTest
import OCTranslateAPI

class TranslateAPIEndToEndTests: XCTestCase {

    func test_endToEndTestServerGETTranslateResult_matchesFixedTestAccountData() {
        switch getTranslateResult() {
        case let .success(item)?:
            XCTFail("Expected error Translate result, got \(item) instead")
        case let .failure(error)?:
            XCTAssertNotNil(error)
        default:
            XCTFail("Expected successful Translate result, got no result instead")
        }
    }

    // MARK: - Helpers

    private func getTranslateResult(file: StaticString = #file, line: UInt = #line) -> LoadTranslateResult<TranslateModel>? {
        let client = URLSessionHTTPClient()
        // Use samples URL from your API
        let testServerURL = URL(string: "https://samples.openTranslatemap.org/data/2.5/Translate?q=London,uk&appid=b6907d289e10d714a6e88b30761fae22")!
        let loader = RemoteTranslateLoader(client: client, url: testServerURL)
        trackMemoryLeaks(instance: client, file: file, line: line)
        trackMemoryLeaks(instance: loader, file: file, line: line)

        let exp = expectation(description: "Wait for load completion")

        var receivedResult: LoadTranslateResult<TranslateModel>?
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }

        wait(for: [exp], timeout: 5.0)
        return receivedResult
    }
}
