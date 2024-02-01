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
    @Published var isAuthenticationComplete = false
    @Published var authenticationStatusMessage = ""
    @Published private(set) var authenticationIndicator: Int = 0
    
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
            
            observeLoginViewModel()
            observeAuthenticationProcesses()
        }
    
    // Function to start the authentication process
    func startAuthFetch() {
        appKeyViewModel.fetchAppKey()
    }
    
    private func observeLoginViewModel() {
        loginViewModel.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.userEmail = user.email
                self?.userPwd = user.password
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
                case .success:
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
}


public enum AuthenticationTitles: CodingKey {
    case AppKey, OAuthKey, SessionKey, Successful
}
