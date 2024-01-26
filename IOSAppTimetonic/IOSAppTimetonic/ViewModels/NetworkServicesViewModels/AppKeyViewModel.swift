//
//  AppKeyViewModel.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 25/01/24.
//

import Foundation
import Combine

class AppKeyViewModel {
    // MARK: - Properties
    @Published var isError: Bool = false
    @Published var existAppKey: Bool = false
    @Published var errorMessage: String?
    @Published var appKey = ""

    private let networkService: NetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization
    /// Initializes the ViewModel with a network service
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    // MARK: - Business Logic
    /// Fetches the appKey from the network service
    func fetchAppKey() {
        networkService.createAppKey()
            .sink(receiveCompletion:  { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.handleError(error)
                }
            }, receiveValue: { [weak self] response in
                self?.appKey = response.appkey
                self?.existAppKey = true
                self?.isError = false
            })
            .store(in: &cancellables)
        
    }
        
    // MARK: - Error Handling
    /// Handles errors from network service
    private func handleError(_ error: NetworkError) {
        // Aquí puedes personalizar el manejo de errores según tu aplicación
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
