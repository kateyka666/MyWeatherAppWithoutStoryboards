//
//  WeatherManager.swift
//  MyWeatherApp
//
//  Created by Екатерина Боровкова on 21.06.2021.
//
import Foundation
import UIKit
import Alamofire

class WeatherManager {
    
    static let shared = WeatherManager()
    //делаем комлишенхендлер(сбегающее замыкание, чтобы передать экземпляр класса сити во вью контроллер+ обновляем интерфейс вью контроллер)
    func fetchRequestWeather(for city : String, completionHandler: @escaping (City) -> Void) {
        let urlRawValue = WeatherURL.apiString.rawValue.replacingOccurrences(of: "*", with: city)
        guard let url = URL(string: urlRawValue) else {return}
        //        создаем сетевую сессию
        let session = URLSession(configuration: .default)
        //        создаем запрос данных через сессию
        let task = session.dataTask(with: url)
        { data, response, error in         //данные, ответ сервера, ошибка
            //            проверяем что данные пришли и кодируем их в текст
            if let data = data  {
                guard let currentWeather = self.JSONDecode(with: data) else { return}
                completionHandler(currentWeather)
            }
        }
        //        без резюме таск не начнет работать
        task.resume()
    }
    
    private func JSONDecode(with data: Data) -> City? {
        do {
            let decoder = JSONDecoder()
            //            декодируем данные(дата) полученные по апи в структуру FoodFromAPI
            let curentWeather = try decoder.decode(WeatherFromAPI.self, from: data)
            //            создаем объект текущей еды, если не получается возвращаем нил
            guard let curentWeather = City(weather:curentWeather ) else {
                return nil
            }
            return curentWeather
        } catch let error as NSError{
            print(error.localizedDescription)
        }
        return nil
    }
    private init? (){}
    
}
