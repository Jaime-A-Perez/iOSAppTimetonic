//
//  AuthenticationProcessProtocol.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 1/02/24.
//

import Foundation

/// Protocol defining the requirements for handling the AppKey authentication process
protocol AuthenticationAppKeyProcessProtocol {
    /// A publisher for observing the state changes in the AppKey authentication process
    var statePublisher: Published<AuthenticationState>.Publisher { get }
    /// Initiates the process of fetching the AppKey
    func fetchAppKey()
}

/// Protocol defining the requirements for handling the OauthKey authentication proces
protocol AuthenticationOauthKeyProcessProtocol {
    /// A publisher for observing the state changes in the OauthKey authentication process
    var statePublisher: Published<AuthenticationState>.Publisher { get }
    /// Initiates the process of fetching the OauthKey
    func createOauthKey(login: String, pwd: String, appkey: String)
}

/// Protocol defining the requirements for handling the SessionKey authentication proces
protocol AuthenticationSessionKeyProcessProtocol {
    /// A publisher for observing the state changes in the SessionKey authentication process
    var statePublisher: Published<AuthenticationState>.Publisher { get }
    /// Initiates the process of fetching the SessionKey
    func createSessionKey(o_u: String, oauthkey: String, restrictions: String)
}
