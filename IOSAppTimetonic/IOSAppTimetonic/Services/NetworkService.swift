//
//  NetworkService.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 21/01/24.
//

import Foundation


protocol NetworkServiceProtocol {
    func createAppKey(completion: @escaping (Result<AppKeyResponseModel, NetworkError>) -> Void)
    func createOauthKey(login: String, pwd: String, appkey: String, completion: @escaping (Result<OauthKeyResponseModel, NetworkError>) -> Void)
    func createSesskey(o_u: String, oauthkey: String, restrictions: String, completion: @escaping (Result<SessKeyResponseModel, NetworkError>) -> Void)
}


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
        
        guard let url = URL(string: "\(Constants.API.baseUrl)\(Constants.API.createAppKey)&appname=api") else {
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
            guard let data = data, let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
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
    
    // Create an OauthKey
    func createOauthKey(login: String, pwd: String, appkey: String, completion: @escaping (Result<OauthKeyResponseModel, NetworkError>) -> Void) {
        
        guard let url = URL(string: "\(Constants.API.baseUrl)\(Constants.API.createOauthkey)") else { return
        }
        
        // Configure the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Configure request body
        let requestBody = [
            "login": login,
            "pwd": pwd,
            "appkey": appkey
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Perform the network task
        let task = session.dataTask(with: request) {data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            // Validate the response and data
            guard let data = data, let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
                        
            // Decode the response
            do {
                let oAuthKeyResponse = try JSONDecoder().decode(OauthKeyResponseModel.self, from: data)
                completion(.success(oAuthKeyResponse))
            } catch {
                completion(.failure(.decodingError))
            }
            
        }
        task.resume()
        
    }
    
    // Create an Sesskey
    func createSesskey(o_u: String, oauthkey: String, restrictions: String, completion: @escaping (Result<SessKeyResponseModel, NetworkError>) -> Void) {
        
        guard let url = URL(string: "\(Constants.API.baseUrl)\(Constants.API.createSesskey)") else { return
        }
        
        // Configure the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Configure request body
        let requestBody = [
            "o_u": o_u,
            "oauthkey": oauthkey,
            "restrictions": restrictions
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Perform the network task
        let task = session.dataTask(with: request) {data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            // Validate the response and data
            guard let data = data, let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
                        
            // Decode the response
            do {
                let oAuthKeyResponse = try JSONDecoder().decode(SessKeyResponseModel.self, from: data)
                completion(.success(oAuthKeyResponse))
            } catch {
                completion(.failure(.decodingError))
            }
            
        }
        task.resume()
        
    }
    
}

enum NetworkError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError
}
