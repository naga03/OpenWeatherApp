//
//  Constants.swift
//  OpenWeatherApp
//
//  Created by Nagasashidhar kummara on 8/20/24.
//

import Foundation
import UIKit

final class Constants: NSObject {
    
    static let sharedInstance = Constants()
    let appId:String = "d093b5607dfbfc5ea32e4905f3d9c8dc"
    let baseUrl : String = "https://api.openweathermap.org/data/2.5/weather?"
    let locationUrl:String = "http://api.openweathermap.org/geo/1.0/direct?"

    private override init() { }
    
}
