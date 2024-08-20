//
//  ViewController.swift
//  OpenWeatherApp
//
//  Created by Nagasashidhar kummara on 8/20/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var SearchBtn: UIButton!
    @IBOutlet weak var locationDetailsTB: UITableView!
    
    private let locationManager = LocationManager()
    private var viewModel: LocationWeatherViewModel!
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    var allSearchResults: [WeatherModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addHeadingLabel()
        // Initialize the view model
        viewModel = LocationWeatherViewModel(weatherService: WeatherService(), viewController: self)
        
        // Load the previously saved city
        if !loadSavedCity() {
            // If there are no saved city, start location updates
            // Set up location manager
            locationManager.delegate = self
            locationManager.startLocationUpdates()
        }
        
        // Set up the loading spinner
        setupActivityIndicator()
        
        activityIndicator.startAnimating()
        // Set up bindings for view model updates
        setupBindings()
        
        // Set up table view data source
        locationDetailsTB.dataSource = self
        
        // Set the text field delegate
        inputTextField.delegate = self
        
        SearchBtn.layer.cornerRadius = 10
        SearchBtn.layer.masksToBounds = true
    }
    
    // MARK: - Actions
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        guard let inputText = inputTextField.text, !inputText.isEmpty else {
            showError(message: "Please enter a valid city name or zip code.")
            return
        }
        saveInputText(inputText)
        activityIndicator.startAnimating()
        fetchWeather(for: inputText)
    }
    
    func addHeadingLabel() {
        // Create the label
        let headingLabel = UILabel()
        headingLabel.text = "Weather View"
        headingLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        headingLabel.textAlignment = .center
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Adding the label to the view
        view.addSubview(headingLabel)
        
        // Setting constraints to center the label horizontally and place it at the top
        NSLayoutConstraint.activate([
            headingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            headingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Setup Bindings
    private func setupBindings() {
        // Bind the reloadTableView closure to reload the table view when data changes
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.locationDetailsTB.reloadData()
                self?.activityIndicator.stopAnimating()
                
                if let displayStr = self?.viewModel.displayStr, !displayStr.isEmpty   {
                    self?.showError(message: displayStr)
                }
            }
        }
    }
    
    // MARK: - Setup Activity Indicator
    private func setupActivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    // MARK: - Helper Methods
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        activityIndicator.stopAnimating()
    }
    
    // Validates zipcode
    private func isValidZipCode(_ input: String) -> Bool {
        let zipCodeRegex = "^[0-9]{5}$"
        let zipCodeTest = NSPredicate(format: "SELF MATCHES %@", zipCodeRegex)
        return zipCodeTest.evaluate(with: input)
    }
    
    // Saving city name or zipcode input text
    private func saveInputText(_ cityName: String) {
        UserDefaults.standard.set(cityName, forKey: "saveInputText")
    }
    
    // To load the Previous searched weather data and fetching on app launch
    private func loadSavedCity() -> Bool {
        if let saveInputText = UserDefaults.standard.string(forKey: "saveInputText") {
            inputTextField.text = saveInputText
            activityIndicator.startAnimating()
            fetchWeather(for: saveInputText)
            return true
        }
        return false
    }
    
    func fetchWeather(for inputText: String) {
        if isValidZipCode(inputText) {
            viewModel.getWeatherByZipCode(zipCode: inputText)
        } else if viewModel.isCityNameValid(inputText) {
            viewModel.getWeather(cityName: inputText)
        } else {
            showError(message: "Please enter a valid city name or zip code.")
        }
    }
    
    func updateSearchResults(with weatherData: WeatherModel) {
        // Insert the new search result at the top of the array
        allSearchResults.insert(weatherData, at: 0)
        
        // Reload the table view
        
        DispatchQueue.main.async {
            self.locationDetailsTB.reloadData()
        }
        
        // Scroll to the top
        if !allSearchResults.isEmpty {
            DispatchQueue.main.async {
                self.locationDetailsTB.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
    }
}

extension ViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSearchResults.count//self.viewModel.weatherModelData != nil ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherDetailsTVC", for: indexPath) as! WeatherDetailsTVC
        
        let weatherData = allSearchResults[indexPath.row]
        cell.configure(with: weatherData)
        
        return cell
    }
}

extension ViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismiss the keyboard
        textField.resignFirstResponder()
        
        // Trigger the search or whatever action you want
        if let searchText = textField.text, !searchText.isEmpty {
            fetchWeather(for: searchText)
        }
        
        return true
    }
}

extension ViewController : LocationManagerDelegate {
    
    // LocationManagerDelegate methods
    func didUpdateLocation(latitude: Double, longitude: Double) {
        print("Latitude: \(latitude), Longitude: \(longitude)")
        viewModel.getWeatherByUserLocation(lat: latitude, lon: longitude)
    }
    
    func didFailWithError(error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
}
