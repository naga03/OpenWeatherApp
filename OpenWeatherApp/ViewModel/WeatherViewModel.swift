//
//  WeatherViewModel.swift
//  OpenWeatherApp
//
//  Created by Nagasashidhar kummara on 8/20/24.
//

import Foundation

typealias WeatherModels = [WeatherModel]

class LocationWeatherViewModel: NSObject {
    
    // MARK: - Properties
    private var weatherService: WeatherServiceProtocol
    var urlStr: String = ""
    weak var viewController: ViewController?
    // Callback to reload the table view when data changes
    var reloadTableView: (() -> Void)?
//    var weatherModelData: WeatherModel? = nil
    
    // MARK: - Initializer
    init(weatherService: WeatherServiceProtocol, viewController: ViewController) {
        self.weatherService = weatherService
        self.viewController = viewController
    }
    
    var weatherModelData: WeatherModel? {
           didSet {
               if let weatherData = weatherModelData {
                   // Use the viewController instance to call the method
                   viewController?.updateSearchResults(with: weatherData)
               }
           }
       }
    
    private var isFetchingWeather = false
    
    var displayStr = String() {
        didSet {
            reloadTableView?()
        }
    }
    
   
    
    // MARK: - URL Construction Methods
    
    /// Constructs a URL based on either city name or zip code.
    func getFullUrl(cityName: String? = nil, zipCode: String? = nil) -> String {
        var query = ""
        let parameters = "&limit=1&appid=" + Constants.sharedInstance.appId
        var str = ""
        
        if let cityName = cityName, !cityName.isEmpty {
            query = "q=\(cityName)"
            str = Constants.sharedInstance.locationUrl + query
        } else if let zipCode = zipCode, !zipCode.isEmpty {
            query = "zip=\(zipCode),us"
            
            str =  Constants.sharedInstance.baseUrl + query
        }
        
        
        return str + parameters
    }
    
    /// Constructs a URL based on latitude and longitude.
    func getLatLonUrl(lat: Double?, lon: Double?) -> String {
        guard let lat = lat, let lon = lon else { return "" }
        let latStr = "lat=\(lat)"
        let lonStr = "&lon=\(lon)"
        return Constants.sharedInstance.baseUrl + latStr + lonStr + "&appid=" + Constants.sharedInstance.appId
    }
    
    
    // MARK: - Weather Fetch Methods
    
    /// Fetches weather data for a given city name or zip code.
    func getWeather(cityName: String? = nil, zipCode: String? = nil) {
        self.displayStr = ""
        weatherService.fetchWeatherData(from: getFullUrl(cityName: cityName, zipCode: zipCode)) { success, model, error in
            if success {
                guard let location = model, !location.isEmpty else {
                    // Handle empty response
                    self.displayStr = "No data found for the provided city name or zip code."
                    self.reloadTableView?()
                    return
                }
                
                if self.isUSLocation(locationModel: location[0]) {
                    
                    self.weatherService.fetchWeatherBasedOnLocation(urlStr: self.getLatLonUrl(lat: location[0].latitude, lon: location[0].longitude)) { success, results, error in
                        if success {
                            guard let results = results else {
                                // Handle empty weather data response
                                self.displayStr = "No detailed weather data available for the provided location."
                                self.reloadTableView?()
                                return
                            }
                            
                            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                                self.weatherModelData = results
                                self.reloadTableView?()
                            }
                        } else if let error = error {
                            self.displayStr = error
                            self.reloadTableView?()
                        }
                    }
                } else {
                    self.displayStr = "This location does not belong to the US."
                    self.reloadTableView?()
                }
            } else if let error = error {
                self.displayStr = error
                self.reloadTableView?()
            }
            
            
        }
    }
    
    func getWeatherByUserLocation(lat: Double?, lon: Double?) {
        guard !isFetchingWeather else {
            print("Fetch already in progress, skipping this call.")
            return
        }
        
        isFetchingWeather = true
        
        self.weatherService.fetchWeatherBasedOnLocation(urlStr: self.getLatLonUrl(lat: lat, lon: lon)) { success, results, error in
            if success, let results = results {
                self.weatherModelData = results
                self.reloadTableView?()
            } else if let error = error {
                self.displayStr = error
                self.reloadTableView?()
            }
        }
    }
    
    func getWeatherByZipCode(zipCode: String) {
        self.displayStr = ""
        self.weatherService.fetchWeatherByZipCode(from: getFullUrl(cityName: nil, zipCode: zipCode)) { success, results, error in
            if success, let results = results {
                self.weatherModelData = results
                self.reloadTableView?()
            } else if let error = error {
                self.displayStr = error
                self.reloadTableView?()
            }
        }
    }
    
    // MARK: - Validation Methods
    
    /// Validates the city name input.
    func isCityNameValid(_ cityName: String?) -> Bool {
        guard let cityName = cityName?.trimmingCharacters(in: .whitespacesAndNewlines), !cityName.isEmpty else {
            self.displayStr = "Please enter a city name."
            return false
        }
        
        // Check if the city name is too short
        if cityName.count < 2 {
            self.displayStr = "City name is too short. Please enter a valid city name."
            return false
        }
        
        // Check if the city name contains only letters and spaces
        let characterSet = CharacterSet.letters.union(CharacterSet.whitespaces)
        if cityName.rangeOfCharacter(from: characterSet.inverted) != nil {
            self.displayStr = "City name contains invalid characters. Please enter a valid city name."
            return false
        }
        
        
        let numberCharacterSet = CharacterSet.decimalDigits
        if cityName.rangeOfCharacter(from: numberCharacterSet) != nil {
            self.displayStr = "City name should not contain numbers. Please enter a valid city name."
            return false
        }
        
        return true
    }
    
    /// Checks if the given location is in the US.
    func isUSLocation(locationModel: LocationModel?) -> Bool {
        guard let locationModel = locationModel else { return false }
        return locationModel.country == "US"
    }
}
