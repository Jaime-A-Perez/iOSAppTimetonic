//
//  Constants.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 21/01/24.
//

import Foundation


struct Constants {
    
    // MARK: - API Constants
    struct API {
        /// Constants related to network API
        
        static let baseUrl = "https://api.timetonic.com"
        
        // Endpoints
        static let createAppKey = "/createAppkey"
        static let createOauthkey = "/createOauthkey"
        static let createSesskey = "/createSesskey"
    }
}
