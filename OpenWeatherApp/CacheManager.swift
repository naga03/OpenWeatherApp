//
//  CacheManager.swift
//  OpenWeatherApp
//
//  Created by Nagasashidhar kummara on 8/20/24.
//

import Foundation

import UIKit

class CacheManager {
    static let shared = CacheManager()
    
    let imageCache = NSCache<NSString, UIImage>()
   
    // Private initializer to prevent multiple instances
    private init() {}
}
