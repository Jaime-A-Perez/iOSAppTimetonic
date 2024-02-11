//
//  AuthenticationState.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 1/02/24.
//

import Foundation

/// 'AuthenticationState' is used across the authentication flow to manage and communicate the current state of authentication actions
enum AuthenticationState {
    case checkingIfAlreadyAuthenticated // Verify if exist key stored
    case idle // The process has not started
    case loading // Authentication is in progress
    case success(String, String) // Authentication succeeded, carrying the `Keys`
    case failure(String) // Authentication failed, with an error message
    case authenticated // Stored authentication keys
}
