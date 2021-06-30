//
//  AlamofireWeatherManager.swift
//  MyWeatherApp
//
//  Created by Екатерина Боровкова on 30.06.2021.
//

import Foundation
import Alamofire

class AlamofireWeatherManager {
    
    static let shared = AlamofireWeatherManager()
    
    func alamofireFetch(for city : String, completionHandler: @escaping (City) -> Void) {
        let urlRawValue = WeatherURL.apiString.rawValue.replacingOccurrences(of: "*", with: city)
//        AF - класс аламофаера, делаем у него запрос по урлу
//        валидейт - фильтрует результаты на небитые данные
//        джейсон метод вернет данные с бека, которые можно распарсить
//        если результат успешен придут данные, если результат провалился, то придет ошибка
//        данные приходят в формате any их нужно будет перевести (для этого вносятся инит и метод в модель City)
        AF.request(urlRawValue)
            .validate()
            .responseDecodable(of: WeatherFromAPI.self ){ dataResponse in
                print(dataResponse.result)
                switch dataResponse.result {
                case .success(let value):
                    guard let city = City(weather: value) else {return}
                    completionHandler(city)

                case .failure(let error):
                    print(error)
                }
            }
    }
    private init? () {}
}
