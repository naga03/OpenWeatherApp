//
//  Extensions.swift
//  OpenWeatherApp
//
//  Created by Nagasashidhar kummara on 8/20/24.
//

import Foundation
import UIKit

extension UIImageView {
    
    func load(url: URL, placeholder: UIImage? = nil) {
        // Set placeholder image if provided
        if let placeholder = placeholder {
            self.image = placeholder
        }
        
        let cacheKey = NSString(string: url.absoluteString)
        
        // Check if the image is already cached
        if let cachedImage = CacheManager.shared.imageCache.object(forKey: cacheKey) {
            self.image = cachedImage
            return
        }
        
        // If not cached, download the image
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                // Cache the image
                CacheManager.shared.imageCache.setObject(image, forKey: cacheKey)
                
                // Set the image on the main thread
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}

extension Double {
    /// Converts temperature from Kelvin to Celsius.
    func toCelsius() -> Double {
        return self - 273.15
    }

    /// Converts temperature from Kelvin to Fahrenheit.
    func toFahrenheit() -> Double {
        return (self - 273.15) * 9/5 + 32
    }

    /// Formats the temperature value as a string with a specified number of decimal places and unit.
    func formattedTemperature(withUnit unit: String = "°C", decimalPlaces: Int = 1) -> String {
        return String(format: "%.\(decimalPlaces)f%@", self, unit)
    }
}
