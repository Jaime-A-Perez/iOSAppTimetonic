//
//  AppKeyResponseModel.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 21/01/24.
//

import Foundation

struct AppKeyResponseModel: Codable {
    let status: String
    let appkey: String
    let id: String
    let createdVNB: String
    let req: String
}
