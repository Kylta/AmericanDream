//
//  ViewController.swift
//  OCExchangeiOS
//
//  Created by Christophe Bugnon on 20/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import UIKit
import OCExchange

class OCExchangeViewController: UIViewController  {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var reloadButton: UIButton!
    var reloadData: (Double) -> Void = { _ in }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        reloadData(Double(label.text!)!)
    }

    @IBAction private func reload() {
        reloadData(Double(label.text!)!)
    }
}

