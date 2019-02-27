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

        sut.viewWillAppear(false)
        
        XCTAssertEqual(sut.textField.text, "1.0")
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

        sut.reloadData?(nil)
        sut.reloadButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(sut.textField.text, "1.0")
    }

    func test_viewDidLoad_rendersValueInExchangeViewCell() {
        let sut = makeSUT()

        sut.viewWillAppear(false)
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = sut.collectionView.dataSource?.collectionView(sut.collectionView, cellForItemAt: indexPath) as! ExchangeCollectionViewCell

        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), 12)
        XCTAssertEqual(cell.codeLabel.text, "GBP")
        XCTAssertEqual(cell.flagLabel.text, "🇬🇧")
        XCTAssertEqual(cell.symbolLabel.text, "£")
        XCTAssertEqual(cell.valueLabel.text, "0.87")
    }

    func test_invalidDataError_doesntLoadData() {
        let sut = makeSUT(isValidData: false)

        sut.viewWillAppear(false)

        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), 0)
    }

    func test_connectivityError_doesntLoadData() {
        let sut = makeSUT(isValidData: true, code: -1009)

        sut.viewWillAppear(false)

        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), 0)
    }

    fileprivate func makeSUT(isValidData: Bool = true, code: Int = 200) -> OCExchangeViewController {
        var sut: OCExchangeViewController!

        if let vc = sb.instantiateInitialViewController() as? OCExchangeViewController {
            let presenter = ExchangeDataPresenter(output: vc)
            let url = URL(string: "http://any-url.com")!
            let client = HTTPClientMock(isValidData: isValidData, code: code)
            let loader = RemoteExchangeLoader(client: client, url: url)
            let exchangeFetcher = FetchExchangeUseCase(loader: loader, output: presenter)
            vc.presenter = presenter
            vc.reloadData = exchangeFetcher.fetch
            vc.loadViewIfNeeded()
            sut = vc
        }
        return sut
    }

    class HTTPClientMock: HTTPClient {
        let isValidData: Bool
        let code: Int

        init(isValidData: Bool, code: Int) {
            self.isValidData = isValidData
            self.code = code
        }

        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            let filePath = Bundle(for: type(of: self)).url(forResource: "genericModel", withExtension: "json")!
            let response = HTTPURLResponse(url: url, statusCode: code, httpVersion: nil, headerFields: nil)!

            if isValidData && code == 200 {
                let data = try! Data(contentsOf: filePath)
                completion(.success(data, response))
            } else if !isValidData {
                let data = Data(bytes: "invalid Data".utf8)
                completion(.success(data, response))
            } else {
                let error = NSError(domain: "error", code: code, userInfo: nil)
                completion(.failure(error))
            }
        }
    }
}
