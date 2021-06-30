//
//  ViewController.swift
//  MyWeatherApp
//
//  Created by Екатерина Боровкова on 21.06.2021.
//

import UIKit
import Alamofire


class ViewController: UIViewController {
    
    static var temperatureLabel: UILabel!
    static var cityLabel: UILabel!
    static var weatherDescriptionLabel: UILabel!
    
    static var weatherIconImage: UIImageView!
    
    static var activityView = UIActivityIndicatorView(style: .large)
    
    static var citSearchBar = UISearchController(searchResultsController: nil)
    
//    private var weather = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createViewLabelsAndImage()
        configurateSearchController()
        firstFetch()
        
    }
    
    private func configurateSearchController() {
        ViewController.citSearchBar.searchResultsUpdater = self
        
        ViewController.citSearchBar.searchBar.placeholder = "Kazan, Samara, Sochi..."
        ViewController.citSearchBar.searchBar.backgroundColor = UIColor(named: "ColorForWeatherController")
        
        navigationItem.searchController = ViewController.citSearchBar
    }
    
    private func createViewLabelsAndImage(){
        view.backgroundColor = UIColor(named: "ColorForWeatherController")
        
        ViewController.activityView.center = CGPoint(x: view.frame.midX, y: 220)
        ViewController.activityView.startAnimating()
        ViewController.activityView.color = .cyan
        
        ViewController.temperatureLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 240, height: 75))
        ViewController.temperatureLabel.center = CGPoint(x: view.frame.midX, y: view.frame.minY + 170)
        ViewController.temperatureLabel.textAlignment = .center
        ViewController.temperatureLabel.font = UIFont(name: "Kohinoor Gujarati Regular", size: 50)
        
        ViewController.cityLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 75))
        ViewController.cityLabel.center = CGPoint(x: view.frame.midX,y:ViewController.temperatureLabel.frame.minY + 100 )
        ViewController.cityLabel.textAlignment = .center
        ViewController.cityLabel.numberOfLines = 0
        ViewController.cityLabel.font = UIFont(name: "Kohinoor Gujarati Bold", size: 30)
        
        ViewController.weatherDescriptionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 360, height: 40))
        ViewController.weatherDescriptionLabel.center = CGPoint(x: view.frame.midX , y:ViewController.cityLabel.frame.minY + 80)
        ViewController.weatherDescriptionLabel.textAlignment = .right
        ViewController.weatherDescriptionLabel.numberOfLines = 0
        ViewController.weatherDescriptionLabel.font = UIFont(name: "Kohinoor Gujarati Regular", size: 25)
        
        ViewController.weatherIconImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 130, height: 130))
        ViewController.weatherIconImage.center = CGPoint(x: view.frame.midX , y: ViewController.weatherDescriptionLabel.frame.minY + 140)
        
        self.view.addSubview(ViewController.temperatureLabel)
        self.view.addSubview(ViewController.cityLabel)
        self.view.addSubview(ViewController.weatherDescriptionLabel)
        self.view.addSubview(ViewController.weatherIconImage)
        self.view.addSubview(ViewController.activityView)
        
    }
    
    private func firstFetch() {
        //        ставим [unowned  self] для того чтобы избежать цикла сильных ссылок, а также развернуть опцинальный вьюконтроллер(типо форсеанврап)
        WeatherManager.shared?.fetchRequestWeather(for: "Moscow")
        {[unowned  self] completionHandler in
            self.updateUI(completionHandler: completionHandler)
        }
    }
    
    private func updateUI(completionHandler: City){
        //        обновляем ui в главном потоке приложения
        DispatchQueue.main.async {
            ViewController.temperatureLabel.text = completionHandler.temperatureString
            ViewController.cityLabel.text = completionHandler.cityName
            ViewController.weatherDescriptionLabel.text = completionHandler.weatherDescription
            ViewController.weatherIconImage.image = UIImage(named: completionHandler.icon)
            ViewController.activityView.stopAnimating()
        }
    }
}

extension ViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text != "" {
            guard let text = searchController.searchBar.text else {return}
            //            проверяем, если текст содержит пробел, то разделяем на два масива и потом соединяем в один без пробела
            let textWithoutSeparators = text.split(separator: " ").joined(separator: "%20").lowercased()
            ViewController.activityView.startAnimating()
            
            AlamofireWeatherManager.shared?.alamofireFetch(for: textWithoutSeparators)
            {[weak  self] completionHandler in
                guard let self = self else { return }
                self.updateUI(completionHandler: completionHandler)
            }

        }
    }
    
}

