//
//  OCExchangePresenter.swift
//  OCExchangeiOS
//
//  Created by Christophe Bugnon on 22/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation
import OCExchange

protocol ExchangeView: class {
    func refreshExchangeView()
}

protocol ExchangePresenter {
    var numberOfCurrencies: Int { get }
    func viewDidLoad()
}

final class ExchangePresenterImplementation: ExchangePresenter {
    fileprivate weak var view: ExchangeView?
    fileprivate let loader: RemoteExchangeLoader

    fileprivate var exchangeData: ExchangeModel?

    var numberOfCurrencies: Int {
        return exchangeData?.currency.count ?? 0
    }

    init(view: ExchangeView, loader: RemoteExchangeLoader) {
        self.view = view
        self.loader = loader
    }

    func viewDidLoad() {
        loader.load { [weak self] result in
            switch result {
            case let .success(item):
                print(item)
                self?.exchangeData = item
                self?.view?.refreshExchangeView()
            case let .failure(error):
                print(error)
            }
        }
    }
}
