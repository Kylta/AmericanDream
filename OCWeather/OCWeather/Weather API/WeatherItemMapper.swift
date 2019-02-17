//
//  WeatherItemMapper.swift
//  OCWeather
//
//  Created by Christophe Bugnon on 17/02/2019.
//  Copyright © 2019 Christophe Bugnon. All rights reserved.
//

import Foundation

internal final class WeatherItemMapper: Decodable {
    let name: String
    let date: Int
    let weather: [Weather]
    let temperature: Double
    let wind: Double
    var outsideWeather: String {
        return weather.map { $0.main }.first!
    }
    var description: String {
        return weather.map { $0.description }.first!
    }
    var formattedDate: String {
        let date = Date(timeIntervalSince1970: TimeInterval(self.date))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
    var weatherItem: WeatherItem {
        return WeatherItem(name: name, date: formattedDate, weather: outsideWeather, description: description, temperature: temperature, wind: wind)
    }

    struct Weather: Decodable {
        let main: String
        let description: String
    }

    init(name: String, date: Int, weather: [Weather], temperature: Double, wind: Double) {
        self.name = name
        self.date = date
        self.weather = weather
        self.temperature = temperature
        self.wind = wind
    }

    enum CodingKeys: String, CodingKey {
        case name, wind, main, weather
        case date = "dt"
    }

    enum TempCodingKeys: String, CodingKey {
        case temp
    }

    enum WindCodingKeys: String, CodingKey {
        case speed
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let tempContainer = try container.nestedContainer(keyedBy: TempCodingKeys.self, forKey: .main)
        let windContainer = try container.nestedContainer(keyedBy: WindCodingKeys.self, forKey: .wind)

        name = try container.decode(String.self, forKey: .name)
        date = try container.decode(Int.self, forKey: .date)
        weather = try container.decode([Weather].self, forKey: .weather)
        temperature = try tempContainer.decode(Double.self, forKey: .temp)
        wind = try windContainer.decode(Double.self, forKey: .speed)
    }

    private static var OK_200: Int {
        return 200
    }

    internal static func map(_ data: Data, _ response: HTTPURLResponse) -> RemoteWeatherLoader.Result {
        guard response.statusCode == OK_200,
            let weatherItemMapper = try? JSONDecoder().decode(WeatherItemMapper.self, from: data) else {
                return .failure(.invalidData)
        }

        return .success(weatherItemMapper.weatherItem)
    }
}
