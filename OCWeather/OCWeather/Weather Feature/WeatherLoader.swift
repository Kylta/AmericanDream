//
//  WeatherLoader.swift
//  OCWeather
//
//  Created by Christophe Bugnon on 17/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

public enum LoadWeatherResult {
    case success(WeatherItem)
    case failure(Error)
}

protocol WeatherLoader {
    func load(completion: @escaping (LoadWeatherResult) -> Void)
}
