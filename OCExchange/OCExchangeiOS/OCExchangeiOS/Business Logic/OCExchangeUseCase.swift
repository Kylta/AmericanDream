//
//  OCExchangeUseCase.swift
//  OCExchangeiOS
//
//  Created by Christophe Bugnon on 26/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation
import OCExchange

protocol FetchExchangeUseCaseOutput {
    func didFetch(_ items: ExchangeModel)
    func failFetch(_ error: Error)
}

final class FetchExchangeUseCase {
    let loader: GenericLoader
    let output: FetchExchangeUseCaseOutput

    init(loader: GenericLoader, output: FetchExchangeUseCaseOutput) {
        self.loader = loader
        self.output = output
    }

    func fetch(updateValue: Double?) {
        loader.load { [weak self] result in
            switch result {
            case let .success(item):
                var currencies = [String: Double]()
                item.currency.forEach { currencies[$0.key] = Double($0.value * (updateValue ?? 1.0)).rounded(toPlaces: 3) }
                self?.output.didFetch(ExchangeModel(timestamp: item.timestamp, date: item.date, base: item.base, currency: currencies))
            case let .failure(error):
                self?.output.failFetch(error)
            }
        }
    }
}

