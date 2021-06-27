//
//  WeatherFromAPI.swift
//  MyWeatherApp
//
//  Created by Екатерина Боровкова on 22.06.2021.
//

import Foundation

// MARK: - WeatherFromAPI
struct WeatherFromAPI: Codable {
    let weather: [WeatherElement]
    let main: Main
    let name: String
}

// MARK: - Main
struct Main: Codable {
    let temp: Double
}

// MARK: - WeatherElement
struct WeatherElement: Codable {
    let weatherDescription, icon: String
    
    enum CodingKeys: String, CodingKey {
        case weatherDescription = "description"
        case icon
    }
}
