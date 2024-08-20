//
//  NetworkRequestHelper.swift
//  OpenWeatherApp
//
//  Created by Nagasashidhar kummara on 8/20/24.
//

import Foundation

enum HTTPContentType {
    case json
    case formUrlencoded
    case none

    var contentType: String? {
        switch self {
        case .json:
            return "application/json"
        case .formUrlencoded:
            return "application/x-www-form-urlencoded"
        case .none:
            return nil
        }
    }
}

class NetworkRequestHelper {

    /// Performs a GET request to the specified URL with the given parameters and headers.
    /// - Parameters:
    ///   - url: The URL string to send the request to.
    ///   - params: A dictionary of query parameters to include in the request.
    ///   - contentType: The HTTP header field specifying the content type.
    ///   - completion: A completion handler that returns a boolean indicating success, and the data received.
    func GET(url: String, params: [String: String], contentType: HTTPContentType, completion: @escaping (Bool, Data?) -> Void) {
        // Build the URL components from the given URL string and parameters
        guard let components = URLComponents(string: url) else {
            print("Error: Cannot create URLComponents")
            completion(false, nil)
            return
        }

        // Safely unwrap the final URL
        guard let finalURL = components.url else {
            print("Error: Cannot create URL")
            completion(false, nil)
            return
        }

        // Create the URLRequest with the GET method
        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"

        // Set the appropriate content type header based on the contentType parameter
        if let contentTypeValue = contentType.contentType {
            request.setValue(contentTypeValue, forHTTPHeaderField: "Content-Type")
        }

        // Use an ephemeral session configuration to avoid caching
        let config = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: config)

        // Perform the data task
        session.dataTask(with: request) { data, response, error in
            // Handle any errors in the request
            if let error = error {
                print("Error: Problem calling GET")
                print("Details: \(error.localizedDescription)")
                completion(false, nil)
                return
            }

            // Ensure we received data
            guard let data = data else {
                print("Error: Did not receive data")
                completion(false, nil)
                return
            }

            // Check the HTTP response status code
            if let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) {
                completion(true, data)
            } else {
                print("Error: HTTP request failed")
                completion(false, nil)
            }
        }.resume() 
    }
}
