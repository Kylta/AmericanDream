//
//  WeatherLoader.swift
//  OCWeather
//
//  Created by Christophe Bugnon on 17/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

enum LoaderWeatherResult {
    case success(WeatherItem)
    case error(Error)
}

protocol WeatherLoader {
    func load(completion: @escaping (LoaderWeatherResult) -> Void)
}
