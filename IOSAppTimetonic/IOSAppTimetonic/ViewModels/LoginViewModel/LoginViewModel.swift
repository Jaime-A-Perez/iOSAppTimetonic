//
//  LoginViewModel.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 20/01/24.
//

import Foundation

// ViewModel for login, adheres to Single Responsibility Principle.
class LoginViewModel: ObservableObject {
    @Published var isActiveAuthView = false
    @Published var user = LoginModel(email: "", password: "")
    private var emailValidator: EmailValidating
    private var passwordValidator: PasswordValidating
    
    // Singleton instance
    static let shared = LoginViewModel()

    init(emailValidator: EmailValidating = EmailValidator(), passwordValidator: PasswordValidating = PasswordValidator()) {
        self.emailValidator = emailValidator
        self.passwordValidator = passwordValidator
    }

    // Computed property to check if email is valid.
    var isValidEmail: Bool {
        emailValidator.isValidEmail(user.email)
    }

    // Computed property to check if password is valid.
    var isValidPassword: Bool {
        passwordValidator.isValidPassword(user.password)
    }
}
