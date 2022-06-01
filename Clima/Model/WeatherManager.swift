//
//  WeatherManager.swift
//  Clima
//
//  Created by Donna on 2022/05/31.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=ed85a014e40b48832e75863a0b5706e0&units=metric"
    
    func fetchWeather (cityName: String) {
        let urlString = "\(weatherUrl)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    func performRequest (urlString: String) {
        // 1. create URL
        if let url = URL(string: urlString) {
            // 2. create url session
            let session = URLSession(configuration: .default)
            
            // 3. give the session a task
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if data != nil {
                    self.parseJSON(weatherData: data!)
                }
                
            }
            
            // 4. start the task
            task.resume()
        }
        
    }
    
    func parseJSON( weatherData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodedData.name)
            print(decodedData.main.temp)
            print(decodedData.weather[0].description)
        } catch {
            print(error)
        }
    }
    
}
