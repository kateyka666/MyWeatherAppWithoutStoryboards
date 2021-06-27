//
//  City.swift
//  MyWeatherApp
//
//  Created by Екатерина Боровкова on 21.06.2021.
//

import Foundation

struct City {
    
    let cityName: String
    let weatherDescription: String
    let temperature: Double
    var temperatureString: String{
        return "\(String(format: "%.1f", temperature))º"
    }
    let icon: String
    
    init? (weather: WeatherFromAPI) {
        cityName = weather.name
        weatherDescription  = weather.weather[0].weatherDescription
        temperature = weather.main.temp
        icon = weather.weather[0].icon
    }
    
}
