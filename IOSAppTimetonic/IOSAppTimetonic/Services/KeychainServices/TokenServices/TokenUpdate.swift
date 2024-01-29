//
//  TokenUpdate.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 29/01/24.
//

import Foundation

class TokenUpdate {
    private let keychainService: KeychainService

    init(keychainService: KeychainService) {
        self.keychainService = keychainService
    }

    func updateToken(_ token: String, service: String, account: String) throws {
        guard let data = token.data(using: .utf8) else { throw KeychainError.invalidTokenConversion }

        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account]
        as [String : Any]
        
        let attributes = [kSecValueData as String: data]

        try keychainService.update(query: query, attributes: attributes)
    }
}
