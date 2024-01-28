//
//  NetworkService.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 21/01/24.
//

import Foundation
import Combine

protocol NetworkServiceProtocol {
    func createAppKey() -> AnyPublisher<AppKeyResponseModel, NetworkError>
    func createOauthKey(login: String, pwd: String, appkey: String) -> AnyPublisher<OauthKeyResponseModel, NetworkError>
    func createSesskey(o_u: String, oauthkey: String, restrictions: String) -> AnyPublisher<SessKeyResponseModel, NetworkError>}


// Network service for handling API requests with implementation protocol
class NetworkService: NetworkServiceProtocol {
    // URLSession dependency for network tasks
    private let session: URLSession
    
    // Dependency injection of URLSession for better testability
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // Create an AppKey
    func createAppKey() -> AnyPublisher<AppKeyResponseModel, NetworkError> {
        
        guard let url = URL(string: "\(Constants.API.baseUrl)\(Constants.API.createAppKey)&appname=api") else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        // Configure the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Perform the network task
        return session.dataTaskPublisher(for: request)
            .mapError { NetworkError.networkError($0) }
            .flatMap { data, response -> AnyPublisher<Data, NetworkError> in
                // Validate the response
                guard (200...299).contains((response as? HTTPURLResponse)?.statusCode ?? 0) else {
                    return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
                }
                return Just(data)
                    .setFailureType(to: NetworkError.self)
                    .eraseToAnyPublisher()
            }
            // Decode the response
            .decode(type: AppKeyResponseModel.self, decoder: JSONDecoder())
            .mapError { _ in NetworkError.decodingError }
            .eraseToAnyPublisher()
    }
    
    // Create an OauthKey
    func createOauthKey(login: String, pwd: String, appkey: String) -> AnyPublisher<OauthKeyResponseModel, NetworkError> {
        guard let url = URL(string: "\(Constants.API.baseUrl)\(Constants.API.createOauthkey)") else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
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

        guard let requestBodyData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            return Fail(error: NetworkError.invalidRequest).eraseToAnyPublisher()
        }

        request.httpBody = requestBodyData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // Perform the network task
        return session.dataTaskPublisher(for: request)
            .mapError { NetworkError.networkError($0) }
            .flatMap { data, response -> AnyPublisher<Data, NetworkError> in
                // Validate the response
                guard (200...299).contains((response as? HTTPURLResponse)?.statusCode ?? 0) else {
                    return Fail(error: .invalidResponse).eraseToAnyPublisher()
                }
                return Just(data)
                    .setFailureType(to: NetworkError.self)
                    .eraseToAnyPublisher()
            }
            // Decode the response
            .decode(type: OauthKeyResponseModel.self, decoder: JSONDecoder())
            .mapError { _ in NetworkError.decodingError }
            .eraseToAnyPublisher()
    }
    
    // Create an Sesskey
    func createSesskey(o_u: String, oauthkey: String, restrictions: String) -> AnyPublisher<SessKeyResponseModel, NetworkError> {
            guard let url = URL(string: "\(Constants.API.baseUrl)\(Constants.API.createSesskey)") else {
                return Fail(error: .invalidURL).eraseToAnyPublisher()
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

            guard let requestBodyData = try? JSONSerialization.data(withJSONObject: requestBody) else {
                return Fail(error: .invalidRequest).eraseToAnyPublisher()
            }

            request.httpBody = requestBodyData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            // Perform the network task
            return session.dataTaskPublisher(for: request)
                .mapError { NetworkError.networkError($0) }
                .flatMap { data, response -> AnyPublisher<Data, NetworkError> in
                    guard (200...299).contains((response as? HTTPURLResponse)?.statusCode ?? 0) else {
                        return Fail(error: .invalidResponse).eraseToAnyPublisher()
                    }
                    return Just(data)
                        .setFailureType(to: NetworkError.self)
                        .eraseToAnyPublisher()
                }
                // Decode the response
                .decode(type: SessKeyResponseModel.self, decoder: JSONDecoder())
                .mapError { _ in NetworkError.decodingError }
                .eraseToAnyPublisher()
        }
    
}

enum NetworkError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError
    case invalidRequest
}
