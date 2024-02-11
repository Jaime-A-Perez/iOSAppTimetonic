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
        
        static let baseUrl = "https://timetonic.com/live/api.php"
        static let baseUrlImage = "https://timetonic.com"
        
        // Endpoints
        static let createAppKey = "/?req=createAppkey"
        static let createOauthkey = "/?req=createOauthkey"
        static let createSesskey = "/?req=createSesskey"
        static let getAllBooks = "&req=getAllBooks"
        
        // version
        static let version = "?version=6.41"
        
        // Credential for tests
        static var userEmail = ""
    }
}
