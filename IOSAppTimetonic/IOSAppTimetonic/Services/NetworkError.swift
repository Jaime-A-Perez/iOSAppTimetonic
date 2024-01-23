//
//  NetworkError.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 23/01/24.
//

import Foundation

// Custom network errors
enum NetworkError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError
}
