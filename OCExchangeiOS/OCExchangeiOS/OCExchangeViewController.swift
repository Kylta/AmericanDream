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
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

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

extension OCExchangeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - DataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfCurrencies
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exchangeCell", for: indexPath) as! ExchangeCollectionViewCell
        presenter.configure(cell: cell, forRow: indexPath.row)
        return cell
    }

    // MARK: - Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 16
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 16, right: 8)
    }
}
