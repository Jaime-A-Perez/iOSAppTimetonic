//
//  SessionKeyViewModel.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 25/01/24.
//

import Foundation
import Combine

/// ViewModel for managing the session key creation process.
class SessionKeyViewModel: AuthenticationSessionKeyProcessProtocol {
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

    let sessionKeyCreated = PassthroughSubject<Void, Never>()
    // MARK: - Business Logic
    /// Creates a session key by making a network request.
    func createSessionKey(o_u: String, oauthkey: String, restrictions: String) {
         state = .loading
         networkService.createSesskey(o_u: o_u, oauthkey: oauthkey, restrictions: restrictions)
             .receive(on: DispatchQueue.main)
             .sink(receiveCompletion: { [weak self] completion in
                 switch completion {
                 case .finished:
                     break
                 case .failure(let error):
                     self?.handleError(error)
                 }
             }, receiveValue: { [weak self] response in
                 self?.state = .success(response.sesskey, "")
             })
             .store(in: &cancellables)
     }

    // MARK: - Error Handling
    /// Handles errors from network service.
    private func handleError(_ error: NetworkError) {
            let errorMessage: String
            switch error {
            case .invalidURL:
                errorMessage = "Invalid URL Error SessionKey"
            case .networkError(let networkError):
                errorMessage = networkError.localizedDescription
            case .invalidResponse:
                errorMessage = "Invalid Response Error SessionKey"
            case .decodingError:
                errorMessage = "Decoding Error SessionKey"
            case .invalidRequest:
                errorMessage = "Invalid Request Error SessionKey"
            }
            state = .failure(errorMessage)
        }
    
    // MARK: - Cancel Subscriptions
        /// Cancels all active subscriptions.
        func cancelSubscriptions() {
            cancellables.forEach { $0.cancel() }
            cancellables.removeAll()
        }
        
        /// Deinitializer to ensure all subscriptions are cancelled.
        deinit {
            cancelSubscriptions()
        }
}
