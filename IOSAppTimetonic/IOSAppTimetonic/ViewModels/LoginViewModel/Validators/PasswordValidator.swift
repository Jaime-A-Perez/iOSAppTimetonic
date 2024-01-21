//
//  PasswordValidator.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 20/01/24.
//

import Foundation

// Protocol for email validation
protocol PasswordValidating {
    func isValidPassword(_ password: String) -> Bool
}

// Concrete class for password validation
class PasswordValidator: PasswordValidating {
    func isValidPassword(_ password: String) -> Bool {
       /*
        The password must have at least one uppercase letter,
        one lowercase letter,
        one number,
        one special character,
        and be between 8 and 20 characters.
        */
        let passwordRegex = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z])(?=.*[!@#$&*.]).{8,20}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }

}
