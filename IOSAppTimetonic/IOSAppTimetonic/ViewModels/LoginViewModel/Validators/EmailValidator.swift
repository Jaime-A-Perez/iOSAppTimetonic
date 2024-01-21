//
//  EmailValidator.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 20/01/24.
//

import Foundation

// Protocol for email validation
protocol EmailValidating {
    func isValidEmail(_ email: String) -> Bool
}

// Concrete class for email validation
class EmailValidator : EmailValidating {
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES[c] %@", emailRegex).evaluate(with: email)
    }
}
