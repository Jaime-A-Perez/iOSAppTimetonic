//
//  TokenDelete.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 29/01/24.
//

import Foundation
import Security

class TokenDeleter {
    private let keychainService: KeychainService

    init(keychainService: KeychainService) {
        self.keychainService = keychainService
    }

    /// Delete a token to the keychain
    func deleteToken(service: String, account: String) throws {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account]
        as [String : Any]
        
        try keychainService.delete(query: query)
    }
}
