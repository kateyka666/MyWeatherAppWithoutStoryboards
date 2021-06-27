//
//  ViewController.swift
//  MyWeatherApp
//
//  Created by Екатерина Боровкова on 21.06.2021.
//

import UIKit

class ViewController: UIViewController {
    
    private var temperatureLabel: UILabel!
    private var cityLabel: UILabel!
    private var weatherDescriptionLabel: UILabel!
    
    private var weatherIconImage: UIImageView!
    
    private var activityView = UIActivityIndicatorView(style: .large)
    
    private var citSearchBar = UISearchController(searchResultsController: nil)
    
    private var weather = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createViewLabelsAndImage()
        configurateSearchController()
        firstFetch()
        
    }
    
    private func configurateSearchController() {
        citSearchBar.searchResultsUpdater = self
        
        citSearchBar.searchBar.placeholder = "Kazan, Samara, Sochi..."
        citSearchBar.searchBar.backgroundColor = UIColor(named: "ColorForWeatherController")
        
        navigationItem.searchController = citSearchBar
    }
    
    private func createViewLabelsAndImage(){
        view.backgroundColor = UIColor(named: "ColorForWeatherController")
        
        activityView.center = CGPoint(x: view.frame.midX, y: 220)
        activityView.startAnimating()
        activityView.color = .cyan
        
        temperatureLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 240, height: 75))
        temperatureLabel.center = CGPoint(x: view.frame.midX, y: view.frame.minY + 170)
        temperatureLabel.textAlignment = .center
        temperatureLabel.font = UIFont(name: "Kohinoor Gujarati Regular", size: 50)
        
        cityLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 75))
        cityLabel.center = CGPoint(x: view.frame.midX,y:temperatureLabel.frame.minY + 100 )
        cityLabel.textAlignment = .center
        cityLabel.numberOfLines = 0
        cityLabel.font = UIFont(name: "Kohinoor Gujarati Bold", size: 30)
        
        weatherDescriptionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 360, height: 40))
        weatherDescriptionLabel.center = CGPoint(x: view.frame.midX , y:cityLabel.frame.minY + 80)
        weatherDescriptionLabel.textAlignment = .right
        weatherDescriptionLabel.numberOfLines = 0
        weatherDescriptionLabel.font = UIFont(name: "Kohinoor Gujarati Regular", size: 25)
        
        weatherIconImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 130, height: 130))
        weatherIconImage.center = CGPoint(x: view.frame.midX , y: weatherDescriptionLabel.frame.minY + 140)
        
        self.view.addSubview(temperatureLabel)
        self.view.addSubview(cityLabel)
        self.view.addSubview(weatherDescriptionLabel)
        self.view.addSubview(weatherIconImage)
        self.view.addSubview(activityView)
        
    }
    
    private func firstFetch() {
        //        ставим [unowned  self] для того чтобы избежать цикла сильных ссылок, а также развернуть опцинальный вьюконтроллер(типо форсеанврап)
        weather.fetchRequestWeather(for: "Moscow")
        {[unowned  self] completionHandler in
            self.updateUI(completionHandler: completionHandler)
        }
    }
    
    private func updateUI(completionHandler: City){
        //        обновляем ui в главном потоке приложения
        DispatchQueue.main.async {
            self.temperatureLabel.text = completionHandler.temperatureString
            self.cityLabel.text = completionHandler.cityName
            self.weatherDescriptionLabel.text = completionHandler.weatherDescription
            self.weatherIconImage.image = UIImage(named: completionHandler.icon)
            self.activityView.stopAnimating()
        }
    }
    
    
}

extension ViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text != "" {
            guard let text = searchController.searchBar.text else {return}
            //            проверяем, если текст содержит пробел, то разделяем на два масива и потом соединяем в один без пробела
            let textWithoutSeparators = text.split(separator: " ").joined(separator: "%20").lowercased()
            activityView.startAnimating()
            weather.fetchRequestWeather(for: textWithoutSeparators)
            {[weak self] completionHandler in
                guard let self = self else {return}
                self.updateUI(completionHandler: completionHandler)
            }
        }
    }
    
}

