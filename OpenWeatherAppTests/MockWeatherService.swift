//
//  MockWeatherService.swift
//  OpenWeatherApp
//
//  Created by Nagasashidhar kummara on 8/20/24.
//

import XCTest
@testable import OpenWeatherApp

final class MockWeatherService: XCTestCase {
    
    var shouldReturnError = false
    var mockWeatherData: WeatherModel?
    var mockLocationData: LocationModel?
    
    
    func fetchWeatherData(from url: String, completion: @escaping (Bool, [LocationModel]?, String?) -> Void) {
        if shouldReturnError {
            completion(false, nil, "Mock error")
        } else {
            let mockLocation = mockLocationData ?? LocationModel(name: "Mock City", latitude: 40.0, longitude: -74.0, country: "US", state: "CA")
            completion(true, [mockLocation], nil)
        }
    }
    
    func fetchWeatherBasedOnLocation(urlStr: String, completion: @escaping (Bool, WeatherModel?, String?) -> Void) {
        if shouldReturnError {
            completion(false, nil, "Mock error")
        } else {
            completion(true, mockWeatherData, nil)
        }
    }
    
    func fetchWeatherByZipCode(from url: String, completion: @escaping (Bool, WeatherModel?, String?) -> Void) {
        if shouldReturnError {
            completion(false, nil, "Mock error")
        } else {
            completion(true, mockWeatherData, nil)
        }
    }
    
}

// Mock data generator
extension MockWeatherService {
    
    // Method to create a mock WeatherModel
    static func createMockWeatherModel() -> WeatherModel {
        let mockCoordinates = Coordinates(longitude: -74.0, latitude: 40.0) //Coord(lon: -74.0, lat: 40.0)
        let mockWeatherDetail = WeatherDetail(id: 800, main: "Clear", description: "clear sky", icon: "01d")
        let mockMainWeather = MainWeather(temperature: 25.0, feelsLikeTemperature: 24.0, minimumTemperature: 22.0, maximumTemperature: 28.0, pressure: 1012, humidity: 53)
        let mockWind = Wind(speed: 3.5, direction: 220)
        let mockRain = Rain(volumeLastHour: 0.0)
        let mockClouds = Clouds(coverage: 0)
        let mockSystemDetails = SystemDetails(type: 1, id: 1234, country: "US", sunrise: 1627893600, sunset: 1627945200)

        return WeatherModel(
            coordinates: mockCoordinates,
            weatherDetails: [mockWeatherDetail],
            base: "stations",
            mainWeather: mockMainWeather,
            visibility: 10000,
            wind: mockWind,
            rain: mockRain,
            clouds: mockClouds,
            timestamp: 1627923600,
            systemDetails: mockSystemDetails,
            timezone: -14400,
            id: 5128581,
            cityName: "New York",
            responseCode: 200
        )
    }
    
    // Method to create a mock LocationModel array
    static func createMockLocationData() -> [LocationModel] {
        return [LocationModel(name: "New York", latitude: 40.0, longitude: -74.0, country: "US", state: "NY")]
    }
}
