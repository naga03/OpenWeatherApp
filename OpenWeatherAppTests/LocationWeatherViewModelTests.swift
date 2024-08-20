//
//  LocationWeatherViewModelTests.swift
//  OpenWeatherAppTests
//
//  Created by Nagasashidhar kummara on 8/20/24.
//

import XCTest
@testable import OpenWeatherApp

final class LocationWeatherViewModelTests: XCTestCase {
    
    var viewModel: LocationWeatherViewModel!
    var mockWeatherService: MockWeatherService!
    
    override func setUpWithError() throws {
        mockWeatherService = MockWeatherService()
        viewModel = LocationWeatherViewModel(weatherService: mockWeatherService as! WeatherServiceProtocol)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockWeatherService = nil
    }
    
    func testGetFullUrlWithCityName() {
        let url = viewModel.getFullUrl(cityName: "New York")
        XCTAssertEqual(url, Constants.sharedInstance.locationUrl + "q=New+York&limit=1&appid=" + Constants.sharedInstance.appId)
    }
    
    func testGetFullUrlWithZipCode() {
        let url = viewModel.getFullUrl(zipCode: "94016")
        XCTAssertEqual(url, Constants.sharedInstance.baseUrl + "zip=94016,us&limit=1&appid=" + Constants.sharedInstance.appId)
    }
    
    
    func testGetWeatherWithCityNameSuccess() {
        // Assign mock data
        mockWeatherService.mockWeatherData = MockWeatherService.createMockWeatherModel()
        //                mockWeatherService.mockLocationData = MockWeatherService.createMockLocationData()
        
        let expectation = self.expectation(description: "Expected fetchWeatherData to succeed.")
        
        viewModel.reloadTableView = {
            expectation.fulfill()
        }
        
        viewModel.getWeather(cityName: "New York")
        
        waitForExpectations(timeout: 2, handler: nil)
        
        XCTAssertEqual(viewModel.weatherModelData?.cityName, "New York")
        XCTAssertEqual(viewModel.displayStr, "")
    }
    
    func testGetWeatherWithCityNameFailure() {
        mockWeatherService.shouldReturnError = true
        
        let expectation = self.expectation(description: "Expected fetchWeatherData to fail.")
        
        viewModel.reloadTableView = {
            expectation.fulfill()
        }
        
        viewModel.getWeather(cityName: "New York")
        
        waitForExpectations(timeout: 2, handler: nil)
        
        XCTAssertNil(viewModel.weatherModelData)
        XCTAssertEqual(viewModel.displayStr, "Mock error")
    }
    
    func testGetWeatherByZipCodeSuccess() {
        mockWeatherService.mockWeatherData = MockWeatherService.createMockWeatherModel()
        
        let expectation = self.expectation(description: "Expected fetchWeatherByZipCode to succeed.")
        
        viewModel.reloadTableView = {
            expectation.fulfill()
        }
        
        viewModel.getWeatherByZipCode(zipCode: "94016")
        
        waitForExpectations(timeout: 2, handler: nil)
        
        XCTAssertEqual(viewModel.weatherModelData?.cityName, "New York")
        XCTAssertEqual(viewModel.displayStr, "")
    }
    
    func testIsCityNameValid() {
        XCTAssertTrue(viewModel.isCityNameValid("San Francisco"))
        XCTAssertFalse(viewModel.isCityNameValid("SF1"))
        XCTAssertFalse(viewModel.isCityNameValid(""))
        XCTAssertFalse(viewModel.isCityNameValid("S"))
        XCTAssertEqual(viewModel.displayStr, "City name is too short. Please enter a valid city name.")
    }
    
    func testIsUSLocation() {
        let location = LocationModel(name: "New York", latitude: 40.0, longitude: -74.0, country: "US", state: "NY")
        XCTAssertTrue(viewModel.isUSLocation(locationModel: location))
        
        let nonUSLocation = LocationModel(name: "Toronto", latitude: 40.0, longitude: -74.0, country: "CA", state: "ON")
        XCTAssertFalse(viewModel.isUSLocation(locationModel: nonUSLocation))
    }
}
