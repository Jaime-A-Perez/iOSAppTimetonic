//
//  LandingPageViewModel.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 8/02/24.
//

import Foundation
import Combine

/// Protocol defining the requirements for a ViewModel responsible for loading books.
protocol GetAllBooksProtocol {
    /// The collection of books currently loaded.
    var books: [Book] { get set }
    
    /// An optional string for storing the last occurred error message, if any.
    var errorMessage: String? { get set }
    
    /// Initiates the process to load books from a remote source.
    func loadBooks()
}

/// ViewModel responsible for managing the landing page's state, including loading books.
class LandingPageViewModel: ObservableObject, GetAllBooksProtocol {
    @Published var books: [Book] = []
    @Published var errorMessage: String?
    
    private var networkService: NetworkServiceProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    /// Loads books by making a network request through `networkService`
    func loadBooks() {
        networkService.getAllBooks()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = "Failed to load books: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                if let fetchedBooks = response.booksResponse?.books {
                    self.books = fetchedBooks
                } else {
                    self.errorMessage = "No books found"
                }
            })
            .store(in: &self.cancellables)
    }
}
