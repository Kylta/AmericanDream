//
//  TranslateAPIEndToEndTests.swift
//  TranslateAPIEndToEndTests
//
//  Created by Christophe Bugnon on 17/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import XCTest
import OCTranslate

class TranslateAPIEndToEndTests: XCTestCase {

    func test_endToEndTestServerGETTranslateResult_matchesFixedTestAccountData() {
        switch getTranslateResult() {
        case let .success(item)?:
            XCTAssertEqual(item.translatedText, "Bonjour")
        case let .failure(error)?:
            XCTFail("Expected result Translate, got \(error) instead")
        default:
            XCTFail("Expected successful Translate result, got no result instead")
        }
    }

    // MARK: - Helpers

    private func getTranslateResult(file: StaticString = #file, line: UInt = #line) -> LoadTranslateResult<TranslateModel>? {
        let client = URLSessionHTTPClient()
        // Use samples URL from your API
        let testServerURL = URL(string: "https://www.googleapis.com/language/translate/v2?key=AIzaSyAZBRy5yETaiffUODxICqMxGBrSnSWXzRQ&target=fr&q=Hello")!
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
