//
//  OCExchangeViewControllerTests
//  OCExchangeiOSTests
//
//  Created by Christophe Bugnon on 20/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import XCTest
@testable import OCExchangeiOS

class OCExchangeCViewControllerTests: XCTestCase {

    private let sb = UIStoryboard(name: "Main", bundle: nil)

    func test_canCreateFromStoryboard() {
        let sut = sb.instantiateInitialViewController()

        XCTAssertTrue(sut is OCExchangeViewController)
    }

    func test_priceLabelOutlet_isConnected() {
        let sut = makeSUT()

        XCTAssertEqual(sut.label.text, "1.0")
    }

    func test_priceButtonOutlet_isConnected() {
        let sut = makeSUT()

        XCTAssertNotNil(sut.reloadButton)
    }

    func test_reloadButtonTap_triggersReloadDataClosure() {
        let sut = makeSUT()

        var callCount = 0
        sut.reloadData = { _ in callCount += 1 }

        XCTAssertEqual(callCount, 0)

        sut.reloadButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(callCount, 1)

        sut.reloadButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(callCount, 2)
    }

    func makeSUT() -> OCExchangeViewController {
        let sut = sb.instantiateInitialViewController() as! OCExchangeViewController
        sut.loadViewIfNeeded()
        return sut
    }
}
