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
        
        // Endpoints
        static let createAppKey = "/?req=createAppkey"
        static let createOauthkey = "/?req=createOauthkey"
        static let createSesskey = "/?req=createSesskey"
    }
}
