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

    func test_updateLabel_renderValueInReloadData() {
        let sut = makeSUT()

        sut.reloadData(2.0)
        sut.reloadButton.sendActions(for: .touchUpInside)

        sut.reloadData = { value in
            XCTAssertEqual(value, 2.0)
        }
    }

    func test_viewDidLoad_transfertExchangeDataInOCExchangeViewController() {
        let sut = makeSUT()

        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), 12)
    }

    func test_viewDidLoad_rendersValueInExchangeViewCell() {
        let sut = makeSUT()

        let indexPath = IndexPath(item: 0, section: 0)
        let cell = sut.collectionView.dataSource?.collectionView(sut.collectionView, cellForItemAt: indexPath) as! ExchangeCollectionViewCell

        XCTAssertEqual(cell.codeLabel.text, "GBP")
        XCTAssertEqual(cell.flagLabel.text, "🇬🇧")
        XCTAssertEqual(cell.symbolLabel.text, "£")
        XCTAssertEqual(cell.valueLabel.text, "0.87")
    }

    fileprivate func makeSUT() -> OCExchangeViewController {
        var sut: OCExchangeViewController!

        if let vc = sb.instantiateInitialViewController() as? OCExchangeViewController {
            let url = URL(string: "http://any-url.com")!
            let client = HTTPClientMock()
            let loader = RemoteExchangeLoader(client: client, url: url)
            let presenter = ExchangePresenterImplementation(view: vc, loader: loader)
            vc.presenter = presenter
            vc.loadViewIfNeeded()
            sut = vc
        }
        return sut
    }

    class HTTPClientMock: HTTPClient {
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            let filePath = Bundle(for: type(of: self)).url(forResource: "genericModel", withExtension: "json")!
            let data = try! Data(contentsOf: filePath)
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            completion(.success(data, response))
        }
    }
}
