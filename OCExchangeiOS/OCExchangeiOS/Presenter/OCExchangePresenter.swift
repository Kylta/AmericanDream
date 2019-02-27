//
//  OCExchangePresenter.swift
//  OCExchangeiOS
//
//  Created by Christophe Bugnon on 22/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation
import OCExchange

protocol ExchangePresenterOutput: class {
    func refreshExchangeView()
    func displayPopUpError(title: String, message: String)
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
    func configure(cell: ExchangeCellView, forRow row: Int)
}

final class ExchangeDataPresenter: ExchangePresenter, FetchExchangeUseCaseOutput {
    fileprivate weak var output: ExchangePresenterOutput?
    fileprivate var exchangeViewModel = [ExchangeViewModel]()
    fileprivate var exchangeData: ExchangeModel?

    var numberOfCurrencies: Int {
        return exchangeViewModel.count
    }

    init(output: ExchangePresenterOutput) {
        self.output = output
    }

    func didFetch(_ result: RemoteExchangeLoader.Result) {
        switch result {
        case let .success(items):
            mapDataToViewModel(data: items)
        case let .failure(error):
            manageError(error: error)
        }
    }

    func configure(cell: ExchangeCellView, forRow row: Int) {
        cell.display(exchangeViewModel: exchangeViewModel[row])
        self.output?.refreshExchangeView()
    }

    fileprivate func mapDataToViewModel(data: ExchangeModel)  {
        let ordererValue = data.currency.sorted(by: { $0.value < $1.value })
        exchangeViewModel = ordererValue.map { tuple -> ExchangeViewModel in
            let flag = data.getEmojiFlag(regionCode: tuple.key)
            let symbol = data.getSymbol(forCurrencyCode: tuple.key)
            return ExchangeViewModel(code: tuple.key, flag: flag, symbol: symbol, currencyValue: String(tuple.value))
        }
        output?.refreshExchangeView()
    }

    fileprivate func manageError(error: Error) {
        switch error as! RemoteExchangeLoader.Error {
        case .connectivity:
            output?.displayPopUpError(title: "Error", message: "Failed to fetch Data, please check your connexion.")
        case .invalidData:
            output?.displayPopUpError(title: "Error", message: "An error system occure, please contact support or try again later.")
        }
    }
}
