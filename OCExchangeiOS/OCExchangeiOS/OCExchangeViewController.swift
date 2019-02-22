//
//  ViewController.swift
//  OCExchangeiOS
//
//  Created by Christophe Bugnon on 20/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import UIKit
import OCExchange

final class OCExchangeViewController: UIViewController  {
    @IBOutlet private(set) weak var label: UILabel!
    @IBOutlet private(set) weak var reloadButton: UIButton!
    @IBOutlet private(set) weak var collectionView: UICollectionView!

    var reloadData: (Double) -> Void = { _ in }
    var presenter: ExchangePresenter!

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self

        presenter.viewDidLoad()
    }

    @IBAction private func reload() {
        reloadData(Double(label.text!)!)
    }
}

extension OCExchangeViewController: ExchangeView {
    func refreshExchangeView() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

extension OCExchangeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfCurrencies
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exchangeCell", for: indexPath)
        return cell
    }
}
