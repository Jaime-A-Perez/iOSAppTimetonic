//
//  MockNetworkService.swift
//  IOSAppTimetonicTests
//
//  Created by Jaime A. Pérez R. on 2/02/24.
//

@testable import IOSAppTimetonic
import XCTest
import Combine

// MockNetworkService should be defined to mimic the behavior of your actual network service, allowing you to control the output.
class MockNetworkService: NetworkServiceProtocol {
    var mockAllBooksResponse: Result<APIResponse, NetworkError>?
    var mockAllBooksJSON: String?
    
    var mockAppKeyResponse: Result<AppKeyResponseModel, NetworkError>?
    var mockOauthKeyResponse: Result<OauthKeyResponseModel, NetworkError>?
    var mockSessKeyResponse: Result<SessKeyResponseModel, NetworkError>?
    
    var mockAppKeyJSON: String?
    var mockOauthKeyJSON: String?
    var mockSessKeyJSON: String?       
    
    
    func createOauthKey(login: String, pwd: String, appkey: String) -> AnyPublisher<OauthKeyResponseModel, NetworkError> {
        let decoder = JSONDecoder()
        // Return a publisher that immediately sends completion or a value based on the mock response
        return Future<OauthKeyResponseModel, NetworkError> { promise in
            guard let json = self.mockOauthKeyJSON else {
                promise(.failure(.invalidResponse))
                return
            }
            
            do {
                let data = Data(json.utf8)
                let oauthKeyResponse = try decoder.decode(OauthKeyResponseModel.self, from: data)
                promise(.success(oauthKeyResponse))
            } catch {
                promise(.failure(.decodingError))
            }
        }
        .eraseToAnyPublisher()
    }
    
    
    func createSesskey(o_u: String, oauthkey: String, restrictions: String) -> AnyPublisher<SessKeyResponseModel, NetworkError> {
        let decoder = JSONDecoder()
        
        return Future<SessKeyResponseModel, NetworkError> { promise in
            guard let json = self.mockSessKeyJSON else {
                promise(.failure(.invalidResponse))
                return
            }
            
            do {
                let data = Data(json.utf8)
                let sessKeyResponse = try decoder.decode(SessKeyResponseModel.self, from: data)
                promise(.success(sessKeyResponse))
            } catch {
                promise(.failure(.decodingError))
            }
        }
        .eraseToAnyPublisher()
    }
    
    
    func createAppKey() -> AnyPublisher<AppKeyResponseModel, NetworkError> {
        let decoder = JSONDecoder()
        
        return Future<AppKeyResponseModel, NetworkError> { promise in
            guard let json = self.mockAppKeyJSON else {
                promise(.failure(.invalidResponse))
                return
            }
            
            do {
                let data = Data(json.utf8)
                let appKeyResponse = try decoder.decode(AppKeyResponseModel.self, from: data)
                promise(.success(appKeyResponse))
            } catch {
                promise(.failure(.decodingError))
            }
        }
        .eraseToAnyPublisher()
    }
    
    
    func getAllBooks() -> AnyPublisher<APIResponse, NetworkError> {
        let decoder = JSONDecoder()
        
        return Future<APIResponse, NetworkError> { promise in
            if let response = self.mockAllBooksResponse {
                switch response {
                case .success(let apiResponse):
                    promise(.success(apiResponse))
                case .failure(let error):
                    promise(.failure(error))
                }
            } else if let json = self.mockAllBooksJSON {
                do {
                    let data = Data(json.utf8)
                    let allBooksResponse = try decoder.decode(APIResponse.self, from: data)
                    promise(.success(allBooksResponse))
                } catch {
                    promise(.failure(.decodingError))
                }
            } else {
                promise(.failure(.invalidResponse))
            }
        }
        .eraseToAnyPublisher()
    }
}
