//
//  WeatherItem.swift
//  OCWeather
//
//  Created by Christophe Bugnon on 17/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

public struct WeatherItem: Equatable {
    public let name: String
    public let date: Int
    public let weather: String
    public let description: String
    public let temperature: Double
    public let wind: Double
}
