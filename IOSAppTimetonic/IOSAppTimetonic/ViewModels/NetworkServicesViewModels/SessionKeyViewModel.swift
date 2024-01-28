//
//  SessionKeyViewModel.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 25/01/24.
//

import Foundation
import Combine

/// ViewModel for managing the session key creation process.
class SessionKeyViewModel {
    // MARK: - Properties
//    @Published var sessionKey: SessKeyResponseModel?
    @Published var isError: Bool = false
    @Published var existSesskey: Bool = false
    @Published var errorMessage: String?
    @Published var sesskey = ""
    
    private let networkService: NetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization
    /// Initializes the ViewModel with a network service.
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    // MARK: - Business Logic
    /// Creates a session key by making a network request.
    func createSessionKey(o_u: String, oauthkey: String, restrictions: String) {
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
                self?.sesskey = response.sesskey
                self?.existSesskey = true
                self?.isError = false
            })
            .store(in: &cancellables)
    }

    // MARK: - Error Handling
    /// Handles errors from network service.
    private func handleError(_ error: NetworkError) {
        self.isError = true
        switch error {
        case .invalidURL:
            self.errorMessage = "invalid URL Error"
        case .networkError(let networkError):
            self.errorMessage = networkError.localizedDescription
        case .invalidResponse:
            self.errorMessage = "invalid Response Error"
        case .decodingError:
            self.errorMessage = "decoding Error"
        case .invalidRequest:
            self.errorMessage = "invalidRequest Error"
        }
    }
}
