//
//  AppKeyViewModel.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 25/01/24.
//

import Foundation
import Combine


class AppKeyViewModel: AuthenticationAppKeyProcessProtocol {
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
    /// Fetches the appKey from the network service
    func fetchAppKey() {
        state = .loading
        networkService.createAppKey()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion:  { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.handleError(error)
                }
            }, receiveValue: { [weak self] response in
                self?.state = .success(response.appkey, "")
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Error Handling
    /// Handles errors from network service
    private func handleError(_ error: NetworkError) {
        let errorMessage: String
        switch error {
        case .invalidURL:
            errorMessage = "Invalid URL Error AppKey"
        case .networkError(let networkError):
            errorMessage = networkError.localizedDescription
        case .invalidResponse:
            errorMessage = "Invalid Response Error AppKey"
        case .decodingError:
            errorMessage = "Decoding Error AppKey"
        case .invalidRequest:
            errorMessage = "InvalidRequest Error AppKey"
        }
        state = .failure(errorMessage)
    }
}
