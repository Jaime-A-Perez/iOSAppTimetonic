//
//  SessKeyResponseModel.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 24/01/24.
//

import Foundation


struct SessKeyResponseModel: Codable {
    let status: String
    let sesskey: String
    let id: String
    let restrictions: Restrictions
    let appName: String
    let createdVNB: String
    let req: String

    struct Restrictions: Codable {
        let carnetCode: String?
        let carnetOwner: String?
        let readonly: Bool
        let hideTables: Bool
        let hideMessages: Bool
        let hideEvents: Bool
        let `internal`: Bool

        enum CodingKeys: String, CodingKey {
            case carnetCode = "carnet_code"
            case carnetOwner = "carnet_owner"
            case readonly, hideTables, hideMessages, hideEvents, `internal`
        }
    }
}
