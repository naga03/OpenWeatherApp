//
//  WeatherDetailsTVC.swift
//  OpenWeatherApp
//
//  Created by Nagasashidhar kummara on 8/20/24.
//

import UIKit

class WeatherDetailsTVC: UITableViewCell {
    
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    // MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state if needed
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        // Custom initialization code for UI components
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        descriptionLabel.textColor = .darkText
        
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.clipsToBounds = true
    }
    
    // MARK: - Configuration Method
    func configure(with weatherData: WeatherModel) {
        
        // Temperature and Feels Like Texts
        let temperatureText = weatherData.mainWeather?.temperature?.toCelsius().formattedTemperature() ?? "Temperature: N/A"
        let feelsLikeText = weatherData.mainWeather?.feelsLikeTemperature?.toCelsius().formattedTemperature(withUnit: "°C") ?? "Feels Like: N/A"
        
        descriptionLabel.text = """
            City Name: \(weatherData.cityName ?? "") \nCountry Name: \(weatherData.systemDetails?.country ?? "") \nTemperature:  \(temperatureText) \nFeels Like: \(feelsLikeText)  \nDescription: \(weatherData.weatherDetails?.first?.description ?? "")
            """
        
        if let iconCode = weatherData.weatherDetails?.first?.icon,
           let url = URL(string: "https://openweathermap.org/img/wn/\(iconCode)@2x.png") {
            iconImageView.load(url: url, placeholder: UIImage(named: "download"))
        } else {
            iconImageView.image = UIImage(named: "download")
        }
    }
}
