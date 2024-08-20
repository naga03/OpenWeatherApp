//
//  OpenWeatherMapModel.swift
//  OpenWeatherApp
//
//  Created by Nagasashidhar kummara on 8/20/24.
//

import Foundation

import Foundation

// MARK: - LocationModel
struct LocationModel: Codable {
    let name: String?
    let latitude, longitude: Double?
    let country, state: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "lon"
        case country, state
    }
}

// To represent an array of locations
typealias Location = [LocationModel]

// MARK: - WeatherModel
struct WeatherModel: Codable {
    let coordinates: Coordinates?
    let weatherDetails: [WeatherDetail]?
    let base: String?
    let mainWeather: MainWeather?
    let visibility: Int?
    let wind: Wind?
    let rain: Rain?
    let clouds: Clouds?
    let timestamp: Int?
    let systemDetails: SystemDetails?
    let timezone, id: Int?
    let cityName: String?
    let responseCode: Int?

    enum CodingKeys: String, CodingKey {
        case coordinates = "coord"
        case weatherDetails = "weather"
        case base
        case mainWeather = "main"
        case visibility, wind, rain, clouds
        case timestamp = "dt"
        case systemDetails = "sys"
        case timezone, id
        case cityName = "name"
        case responseCode = "cod"
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let coverage: Int?

    enum CodingKeys: String, CodingKey {
        case coverage = "all"
    }
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let longitude, latitude: Double?

    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}

// MARK: - MainWeather
struct MainWeather: Codable {
    let temperature, feelsLikeTemperature, minimumTemperature, maximumTemperature: Double?
    let pressure, humidity: Int?

    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feelsLikeTemperature = "feels_like"
        case minimumTemperature = "temp_min"
        case maximumTemperature = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Rain
struct Rain: Codable {
    let volumeLastHour: Double?

    enum CodingKeys: String, CodingKey {
        case volumeLastHour = "1h"
    }
}

// MARK: - SystemDetails
struct SystemDetails: Codable {
    let type, id: Int?
    let country: String?
    let sunrise, sunset: Int?
}

// MARK: - WeatherDetail
struct WeatherDetail: Codable {
    let id: Int?
    let main, description, icon: String?
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let direction: Int?

    enum CodingKeys: String, CodingKey {
        case speed
        case direction = "deg"
    }
}
