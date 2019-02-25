//
//  ExchangeCollectionViewCell.swift
//  OCExchangeiOS
//
//  Created by Christophe Bugnon on 22/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import UIKit

class ExchangeCollectionViewCell: UICollectionViewCell, ExchangeCellView {
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var flagLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = 10
    }

    func display(exchangeViewModel: ExchangeViewModel) {
        codeLabel.text = exchangeViewModel.code
        flagLabel.text = exchangeViewModel.flag
        valueLabel.text = exchangeViewModel.currencyValue
        symbolLabel.text = exchangeViewModel.symbol
    }
}
