//
//  WeatherManager.swift
//  Clima
//
//  Created by Donna on 2022/05/31.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

struct WeatherManager {
    let weatherUrl: String = "https://api.openweathermap.org/data/2.5/weather?appid=ed85a014e40b48832e75863a0b5706e0&units=metric"
    weak var delegate: WeatherManagerDelegate?
    func fetchWeather (cityName: String ) {
        let urlString = "\(weatherUrl)&q=\(cityName)"
        performRequest(with: urlString)
    }
    func fetchWeather (latitude: CLLocationDegrees, longitute: CLLocationDegrees ) {
        let urlString = "\(weatherUrl)&lat=\(latitude)&lon=\(longitute)"
        performRequest(with: urlString)
    }
    
    func performRequest (with urlString: String) {
        // 1. create URL
        if let url = URL(string: urlString) {
            // 2. create url session
            let session = URLSession(configuration: .default)
            
            // 3. give the session a task
            let task = session.dataTask(with: url) {(data, _, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if data != nil {
                    if let weather = self.parseJSON(data!) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            // 4. start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let name = decodedData.name
            let temp = decodedData.main.temp
            let id = decodedData.weather[0].id
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}

    //https://hyerios.tistory.com/16 // retain cycle?
protocol WeatherManagerDelegate: AnyObject {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}
