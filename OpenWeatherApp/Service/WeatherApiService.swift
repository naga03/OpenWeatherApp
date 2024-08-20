//
//  WeatherApiService.swift
//  OpenWeatherApp
//
//  Created by Nagasashidhar kummara on 8/20/24.
//

import Foundation

protocol WeatherServiceProtocol {
    /// Fetches weather data from the specified URL.
    /// - Parameters:
    ///   - urlString: The URL string to request the weather data from.
    ///   - completion: A completion handler that returns whether the request was successful, the resulting `Location` array if successful, and an optional error message.
    func fetchWeatherData(from urlString: String, completion: @escaping (_ success: Bool, _ results: Location?, _ error: String?) -> Void)
    
   
        func fetchWeatherBasedOnLocation(urlStr:String,completion: @escaping (_ success: Bool, _ results: WeatherModel?, _ error: String?) -> ())
    
    
    /// Fetches weather data based on the given ZIP code.
        /// - Parameters:
        ///   - urlString: The URL string to request the weather data from.
        ///   - completion: A completion handler that returns whether the request was successful, the resulting `WeatherModel` if successful, and an optional error message.
        func fetchWeatherByZipCode(from urlString: String, completion: @escaping (_ success: Bool, _ weather: WeatherModel?, _ error: String?) -> Void)


}

class WeatherService: WeatherServiceProtocol {
    
    func fetchWeatherData(from urlString: String, completion: @escaping (Bool, Location?, String?) -> Void) {
        NetworkRequestHelper().GET(url: urlString, params: ["":""], contentType: .json) { success, data in
            if success {
                do {
                    let model = try JSONDecoder().decode(Location.self, from: data!)
                    completion(true, model, nil)
                } catch {
                    completion(false, nil, "Error: Trying to parse Location to model")
                }
            } else {
                completion(false, nil, "Error: Location GET Request failed")
            }
        }
    }
    
    func fetchWeatherBasedOnLocation(urlStr: String, completion: @escaping (Bool, WeatherModel?, String?) -> ()) {
        NetworkRequestHelper().GET(url: urlStr, params: ["" : ""], contentType: .json) { success, data in
            if success {
                do {
                    let model = try JSONDecoder().decode(WeatherModel.self, from: data!)
                    completion(true, model, nil)
                } catch {
                    completion(false, nil, "Error: Trying to parse WeahterModel to model")
                }
            } else {
                completion(false, nil, "Error: Weahter GET Request failed")
            }
        }
    }
    
    func fetchWeatherByZipCode(from urlString: String, completion: @escaping (Bool, WeatherModel?, String?) -> Void) {
        NetworkRequestHelper().GET(url: urlString, params: ["" : ""], contentType: .json) { success, data in
            if success {
                do {
                    let model = try JSONDecoder().decode(WeatherModel.self, from: data!)
                    completion(true, model, nil)
                } catch {
                    completion(false, nil, "Error: Trying to parse WeahterModel to model")
                }
            } else {
                completion(false, nil, "Error: Weahter GET Request failed")
            }
        }
    }
}
