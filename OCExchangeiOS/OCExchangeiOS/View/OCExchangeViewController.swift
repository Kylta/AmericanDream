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
    @IBOutlet weak var label: CustomLabel!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    var reloadData: (Double) -> Void = { _ in }
    var presenter: ExchangePresenter!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
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

    func displayPopUpError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}

extension OCExchangeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - Layout
    fileprivate func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        collectionView.collectionViewLayout = layout
    }

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
