//
//  LocationManager.swift
//  OpenWeatherApp
//
//  Created by Nagasashidhar kummara on 8/20/24.
//
import Foundation
import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocation(latitude: Double, longitude: Double)
    func didFailWithError(error: Error)
}

class LocationManager: NSObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    weak var delegate: LocationManagerDelegate?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    func startLocationUpdates() {
        // Location updates will now only be managed in locationManagerDidChangeAuthorization
        checkAuthorizationStatus()
    }

    private func checkAuthorizationStatus() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            DispatchQueue.global().async {
                self.locationManager.startUpdatingLocation()
            }
        case .denied, .restricted:
            print("Location access denied/restricted")
        case .notDetermined:
            print("Location permission not determined yet")
        @unknown default:
            print("A new case is available that isn't being handled")
        }
    }

    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }

    // CLLocationManagerDelegate methods
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorizationStatus()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            delegate?.didUpdateLocation(latitude: latitude, longitude: longitude)
            stopLocationUpdates()  // Stop updates once we get the location
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFailWithError(error: error)
    }
}
