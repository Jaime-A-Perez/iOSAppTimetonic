//
//  oAuthKeyResponseModel.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 24/01/24.
//

import Foundation

struct OauthKeyResponse: Codable {
    let status: String
    let oauthkey: String
    let id: String
    let o_u: String
    let createdVNB: String
    let req: String
}
