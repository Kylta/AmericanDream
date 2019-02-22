//
//  AppDelegate.swift
//  OCExchangeiOS
//
//  Created by Christophe Bugnon on 20/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import UIKit
import OCExchange

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if let vc = window?.rootViewController as? OCExchangeViewController {
            let client = URLSessionHTTPClient()
            let url = URL(string: "http://data.fixer.io/api/latest?access_key=356dae2235195b60bb99471f9de6c140&base?=EUR&symbols=USD,GBP,CAD,AUD,JPY,CNY,INR,SGD,BRL,IDR,VND,MXN")!
            let loader = RemoteExchangeLoader(client: client, url: url)
            let presenter = ExchangePresenterImplementation(view: vc, loader: loader)
            vc.presenter = presenter
        }

        return true
    }
}

