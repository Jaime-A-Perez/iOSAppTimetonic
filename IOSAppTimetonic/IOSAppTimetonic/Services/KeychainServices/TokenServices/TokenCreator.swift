//
//  TokenCreator.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 28/01/24.
//

import Foundation
import Security


class TokenCreator {
    private let keychainService: KeychainService

    init(keychainService: KeychainService) {
        self.keychainService = keychainService
    }
    
    /// Saves a token to the keychain
    func saveToken(_ token: String, service: String, account: String) throws {
        guard let data = token.data(using: .utf8) else { throw  KeychainError.invalidTokenConversion }
            let query = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service,
                kSecAttrAccount as String: account,
                kSecValueData as String: data
            ] as [String : Any]
        
            try keychainService.add(query: query)
        }
}
