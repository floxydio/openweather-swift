//
//  WeatherManager.swift
//  weatherapp
//
//  Created by Dio Rovelino on 28/06/23.
//

import Foundation
import CoreLocation


class WeatherManager {
    var API_KEY = "61b9e516f0c9d65325b23fe0b8968236"
    
    func fetchDataWeather(city: String) async throws -> ResponseBody {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(API_KEY)") else {
            fatalError("Cannot Connect URL")
        }
        let urlRequest = URLRequest(url: url)
        
        let (data,response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Something went wrong")
        }
        
        let decodedData = try JSONDecoder().decode(ResponseBody.self,from:data)
        return decodedData
    }
}

struct ResponseBody: Decodable {
    var coord: CoordinatesResponse
    var weather: [WeatherResponse]
    var main: MainResponse
    var name: String
    var wind: WindResponse

    struct CoordinatesResponse: Decodable {
        var lon: Double
        var lat: Double
    }

    struct WeatherResponse: Decodable {
        var id: Double
        var main: String
        var description: String
        var icon: String
    }

    struct MainResponse: Decodable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Double
        var humidity: Double
    }
    
    struct WindResponse: Decodable {
        var speed: Double
        var deg: Double
    }
}

extension ResponseBody.MainResponse {
    var feelsLike: Double { return feels_like }
    var tempMin: Double { return temp_min }
    var tempMax: Double { return temp_max }
}
