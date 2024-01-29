//
//  KeychainService.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 28/01/24.
//

import Foundation
import Security

// Protocol defining Keychain operations
protocol KeychainServiceProtocol {
    func add(query: [String: Any]) throws
    func update(query: [String: Any], attributes: [String: Any]) throws
    func delete(query: [String: Any]) throws
    func copyMatching(query: [String: Any]) throws -> Data?
}

// Default implementation of KeychainService
class KeychainService: KeychainServiceProtocol {
    /// Adds an item to the Keychain with the specified query parameters
    func add(query: [String: Any]) throws {
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { throw KeychainError.addFailed(status) }
    }
    
    /// Updates an existing Keychain item matching the given query with new attributes
    func update(query: [String: Any], attributes: [String: Any]) throws {
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard status == errSecSuccess else { throw KeychainError.updateFailed(status) }
    }
    
    /// Deletes a Keychain item matching the given query
    func delete(query: [String: Any]) throws {
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess else { throw KeychainError.deleteFailed(status) }
    }
    
    /// Retrieves a Keychain item matching the given query and returns its data
    func copyMatching(query: [String: Any]) throws -> Data? {
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { throw KeychainError.copyMatchingFailed(status) }
        guard status == errSecSuccess else { throw KeychainError.copyMatchingFailed(status) }
        guard let data = item as? Data else { throw KeychainError.unexpectedDataFormat }
        return data
    }
}

// Keychain error enumeration
enum KeychainError: Error {
    case addFailed(OSStatus)
    case updateFailed(OSStatus)
    case deleteFailed(OSStatus)
    case copyMatchingFailed(OSStatus)
    case unexpectedDataFormat
}
