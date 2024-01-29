//
//  TokenReader.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 28/01/24.
//

import Foundation
import Security

class TokenReader {
    private let keychainService: KeychainService
    
    init(keychainService: KeychainService) {
        self.keychainService = keychainService
    }
    
    func retrieveToken(service: String, account: String) throws -> String? {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne]
        as [String : Any]
        
        guard let data = try keychainService.copyMatching(query: query) else {
            throw KeychainError.unexpectedDataFormat
        }
        
        guard let token = String(data: data, encoding: .utf8) else {
            throw KeychainError.unexpectedDataFormat
        }
        
        return token
    }
}
