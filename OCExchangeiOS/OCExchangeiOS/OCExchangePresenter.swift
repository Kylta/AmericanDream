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

protocol ExchangeCellView {
    func display(exchangeViewModel: ExchangeViewModel)
}

struct ExchangeViewModel {
    let code: String
    let flag: String
    let symbol: String
    let currencyValue: String
}

protocol ExchangePresenter {
    var numberOfCurrencies: Int { get }
    func viewDidLoad()
    func configure(cell: ExchangeCellView, forRow row: Int)
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

    func configure(cell: ExchangeCellView, forRow row: Int) {
        let ordererValue = exchangeData?.currency.sorted(by: { $0.value < $1.value })

        if let dictionary = ordererValue?[row],
            let flag = exchangeData?.getEmojiFlag(regionCode: dictionary.key),
            let symbol = exchangeData?.getSymbol(forCurrencyCode: dictionary.key) {
            cell.display(exchangeViewModel: ExchangeViewModel(code: dictionary.key, flag: flag, symbol: symbol, currencyValue: String(dictionary.value)))
        }
    }
}
