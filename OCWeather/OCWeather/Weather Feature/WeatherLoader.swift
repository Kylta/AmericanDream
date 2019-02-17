//
//  WeatherLoader.swift
//  OCWeather
//
//  Created by Christophe Bugnon on 17/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

public enum LoadWeatherResult<Error: Swift.Error> {
    case success(WeatherItem)
    case failure(Error)
}

protocol WeatherLoader {
    associatedtype Error: Swift.Error
    func load(completion: @escaping (LoadWeatherResult<Error>) -> Void)
}
