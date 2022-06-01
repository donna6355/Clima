//
//  WeatherData.swift
//  Clima
//
//  Created by Donna on 2022/06/01.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
// Codable = Decodable + Encodable

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
}
