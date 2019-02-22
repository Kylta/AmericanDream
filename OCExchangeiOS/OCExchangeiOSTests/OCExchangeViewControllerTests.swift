//
//  OCExchangeViewControllerTests
//  OCExchangeiOSTests
//
//  Created by Christophe Bugnon on 20/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import XCTest
import OCExchange
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

    func test_viewDidLoad_transfertExchangeDataInOCExchangeViewController() {
        let sut = makeSUT()

        let exp = expectation(description: "Wait for completion")
        sut.refreshExchangeView()
        exp.fulfill()

        wait(for: [exp], timeout: 1)

        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), 12)
    }

    func makeSUT() -> OCExchangeViewController {
        var sut: OCExchangeViewController!
        if let vc = sb.instantiateInitialViewController() as? OCExchangeViewController {
            let client = URLSessionHTTPClient()
            let url = URL(string: "http://data.fixer.io/api/latest?access_key=356dae2235195b60bb99471f9de6c140&base?=EUR&symbols=USD,GBP,CAD,AUD,JPY,CNY,INR,SGD,BRL,IDR,VND,MXN")!
            let loader = RemoteExchangeLoader(client: client, url: url)
            let presenter = ExchangePresenterImplementation(view: vc, loader: loader)
            vc.presenter = presenter
            vc.loadViewIfNeeded()
            sut = vc
        }
        return sut
    }
}
