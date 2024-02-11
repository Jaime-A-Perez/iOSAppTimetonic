//
//  AuthVerificationViewModel.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 30/01/24.
//


import Foundation
import Combine

/// ViewModel for handling authentication verification
class AuthVerificationViewModel : ObservableObject {
    // MARK: - Properties
    // Properties related to authentication state
    @Published private(set) var latestErrorMessage = ""
    @Published private(set) var isAuthenticating = true
    @Published private(set) var authenticationIndicator: Int = 0
    @Published var keyManagementError = ""
    @Published var isAuthenticationComplete = false
    @Published var authenticationStatusMessage = ""
    @Published var authenticationState : AuthenticationState = .checkingIfAlreadyAuthenticated
    
       
    // ViewModel dependencies for different authentication keys
    private var appKeyViewModel: AuthenticationAppKeyProcessProtocol
    private var oauthKeyViewModel: AuthenticationOauthKeyProcessProtocol
    private var sessionKeyViewModel: AuthenticationSessionKeyProcessProtocol
    private var loginViewModel: LoginViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published private var userEmail = ""
    @Published private var userPwd = ""
    
    // Singleton instance
    static let shared = AuthVerificationViewModel(
        appKeyViewModel: AppKeyViewModel(networkService: NetworkService()),
        oauthKeyViewModel: OauthKeyViewModel(networkService: NetworkService()),
        sessionKeyViewModel: SessionKeyViewModel(networkService: NetworkService()),
        loginViewModel: LoginViewModel.shared
    )
    
    // MARK: - Initialization
    private init(
        appKeyViewModel: AuthenticationAppKeyProcessProtocol,
        oauthKeyViewModel: AuthenticationOauthKeyProcessProtocol,
        sessionKeyViewModel: AuthenticationSessionKeyProcessProtocol,
        loginViewModel: LoginViewModel) {
            self.appKeyViewModel = appKeyViewModel
            self.oauthKeyViewModel = oauthKeyViewModel
            self.sessionKeyViewModel = sessionKeyViewModel
            self.loginViewModel = loginViewModel
            
            checkIfAlreadyAuthenticated()
            observeLoginViewModel()
            observeAuthenticationProcesses()
        }
    
    // MARK: - Authentication
    
    /// Function to start the authentication process
    func startAuthFetch() {
        appKeyViewModel.fetchAppKey()
    }
    
    private func observeLoginViewModel() {
        loginViewModel.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.userEmail = user.email
                self?.userPwd = user.password
                Constants.API.userEmail = user.email
            }
            .store(in: &cancellables)
    }
    
    private func observeAuthenticationProcesses() {
        // Observing authentication processes
        let appKeyState = appKeyViewModel.statePublisher
        let oauthKeyState = oauthKeyViewModel.statePublisher
        let sessionKeyState = sessionKeyViewModel.statePublisher
        
        
        
        // Observing AppKeyViewModel state
        appKeyState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .success(let appKey, _):
                    self?.authenticationStatusMessage = AuthenticationTitles.OAuthKey.stringValue
                    self?.oauthKeyViewModel.createOauthKey(login: self!.userEmail, pwd: self!.userPwd, appkey: appKey)
                    self?.authenticationIndicator = 1
                case .failure(let errorMessage):
                    self?.latestErrorMessage = errorMessage
                    self?.isAuthenticating = false
                default:
                    break
                }
            }
            .store(in: &cancellables)
        
        // Observing OauthKeyViewModel state
        oauthKeyState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .success(let oauthKey, let o_u):
                    self?.storeKey(o_u, forAccount: "o_u")
                    self?.authenticationStatusMessage = AuthenticationTitles.SessionKey.stringValue
                    self?.sessionKeyViewModel.createSessionKey(o_u: o_u, oauthkey: oauthKey, restrictions: "")
                    self?.authenticationIndicator = 2
                case .failure(let errorMessage):
                    self?.latestErrorMessage = errorMessage
                    self?.isAuthenticating = false
                default:
                    break
                }
            }
            .store(in: &cancellables)
        
        // Observing SessionKeyViewModel state
        sessionKeyState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .success(let sessKey, _):
                    // Storing sessKey in keychaing
                    self?.storeKey(sessKey, forAccount: "Sessk")
                    self?.isAuthenticating = false
                    self?.isAuthenticationComplete = true
                    self?.authenticationStatusMessage = AuthenticationTitles.Successful.stringValue
                    self?.authenticationIndicator = 3
                case .failure(let errorMessage):
                    self?.latestErrorMessage = errorMessage
                    self?.isAuthenticating = false
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    
    // MARK: - Token Management
    
    /// Stores a key in the keychain for a given account type
    private func storeKey(_ key: String, forAccount accountType: String) {
        do {
            let tokenCreator = TokenCreator(keychainService: KeychainService())
            try tokenCreator.saveToken(key, service: Constants.API.baseUrl, account: accountType)
        } catch {
            self.keyManagementError = "Failed to store token: \(error)"
        }
    }
    
    /// Deletes the session key from the keychain
    func sessKeyDelete() -> Bool {
        do {
            loginViewModel.user.email = ""
            loginViewModel.user.password = ""
            Constants.API.userEmail = ""
            userEmail = ""
            userPwd = ""
            isAuthenticating = true
            authenticationIndicator = 0
            keyManagementError = ""
            isAuthenticationComplete = false
            authenticationStatusMessage = ""
            authenticationState = .idle
            loginViewModel.isActiveAuthView = false
            let deleter = TokenDeleter(keychainService: KeychainService())
            let _ = try deleter.deleteToken(service: Constants.API.baseUrl, account: "Sessk")
            let _ = try deleter.deleteToken(service: Constants.API.baseUrl, account: "o_u")
            return true
        }catch {
            self.keyManagementError = "Could not delete stored key: \(error)"
            return false
        }
    }
    

    // MARK: - Authentication Status
    
    /// Verifies whether the necessary keys are stored in the keychain
    private func verifyKeyStored() -> Bool {
        do {
            let tokenReader = TokenReader(keychainService: KeychainService())
            let k1 = try tokenReader.retrieveToken(service: Constants.API.baseUrl, account: "Sessk")
            let k2 = try tokenReader.retrieveToken(service: Constants.API.baseUrl, account: "o_u")
            if (k1 != "") && (k2 != "") {return true} else { return false}
        } catch {
            self.keyManagementError = "Could not verify stored key: \(error)"
            return false
        }
    }
    
    /// Checks if the user is already authenticated by verifying stored keys
    func checkIfAlreadyAuthenticated() {
        Just(verifyKeyStored())
            .delay(for: 0.5, scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] isAuthenticated in
                self?.authenticationState = isAuthenticated ? .authenticated : .idle
            })
            .store(in: &cancellables)
    }
    
   
}


public enum AuthenticationTitles: CodingKey {
    case AppKey, OAuthKey, SessionKey, Successful
}



