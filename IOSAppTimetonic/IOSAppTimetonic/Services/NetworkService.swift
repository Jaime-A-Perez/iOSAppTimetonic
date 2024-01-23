//
//  NetworkService.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 21/01/24.
//

import Foundation

// Network service for handling API requests with implementation protocol
class NetworkService: NetworkServiceProtocol {
    // URLSession dependency for network tasks
    private let session: URLSession
    
    // Dependency injection of URLSession for better testability
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // Create an AppKey
    func createAppKey(completion: @escaping (Result<AppKeyResponseModel, NetworkError>) -> Void) {
        
        guard let url = URL(string: Constants.API.baseUrl + Constants.API.createAppKey) else {
            completion(.failure(.invalidURL))
            return
        }
        
        // Configure the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Perform the network task
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            // Validate the response and data
            guard let data = data, let httpResponse = response as? HTTPURLResponse, (httpResponse.statusCode >= 200 && httpResponse.statusCode <= 299) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            // Decode the response
            do {
                let appKeyResponse = try JSONDecoder().decode(AppKeyResponseModel.self, from: data)
                completion(.success(appKeyResponse))
            } catch {
                completion(.failure(.decodingError))
            }
            
        }
        task.resume()
    }
}
