//
//  OauthKeyViewModel.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 25/01/24.
//

import Foundation
import Combine

/// ViewModel for managing OAuth key fetching and creation.
class OauthKeyViewModel: AuthenticationOauthKeyProcessProtocol {
    // MARK: - Properties
    @Published private(set) var state = AuthenticationState.idle
    
    private let networkService: NetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - AuthenticationProcess Publisher
    var statePublisher: Published<AuthenticationState>.Publisher { $state }
    
    // MARK: - Initialization
    /// Initializes the ViewModel with a network service
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: - Business Logic
    /// Creates an OAuth key using provided credentials
    func createOauthKey(login: String, pwd: String, appkey: String) {
            state = .loading
            networkService.createOauthKey(login: login, pwd: pwd, appkey: appkey)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.handleError(error)
                    }
                }, receiveValue: { [weak self] response in
                    self?.state = .success(response.oauthkey,response.o_u)
                })
                .store(in: &cancellables)
        }

    // MARK: - Error Handling
    /// Handles errors from network service.
    private func handleError(_ error: NetworkError) {
            let errorMessage: String
            switch error {
            case .invalidURL:
                errorMessage = "Invalid URL Error OauthKey"
            case .networkError(let networkError):
                errorMessage = networkError.localizedDescription
            case .invalidResponse:
                errorMessage = "Invalid Response Error OauthKey"
            case .decodingError:
                errorMessage = "Decoding Error OauthKey"
            case .invalidRequest:
                errorMessage = "Invalid Request Error OauthKey"
            }
            state = .failure(errorMessage)
        }
}
