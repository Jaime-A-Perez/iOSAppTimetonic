//
//  OauthKeyViewModel.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 25/01/24.
//

import Foundation
import Combine

/// ViewModel for managing OAuth key fetching and creation.
class OauthKeyViewModel {
    // MARK: - Properties
    @Published var isError: Bool = false
    @Published var existOauthKey: Bool = false
    @Published var errorMessage: String?
    private let networkService: NetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization
    /// Initializes the ViewModel with a network service
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    // MARK: - Business Logic
    /// Creates an OAuth key using provided credentials
    func createOauthKey(login: String, pwd: String, appkey: String) {
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
                // Note: Consider reevaluating the flow and dependencies here.
                self?.existOauthKey = true
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
            self.errorMessage = "Invalid URL Error"
        case .networkError(let networkError):
            self.errorMessage = networkError.localizedDescription
        case .invalidResponse:
            self.errorMessage = "Invalid Response Error"
        case .decodingError:
            self.errorMessage = "Decoding Error"
        case .invalidRequest:
            self.errorMessage = "Decoding Error"
        }
    }
}
