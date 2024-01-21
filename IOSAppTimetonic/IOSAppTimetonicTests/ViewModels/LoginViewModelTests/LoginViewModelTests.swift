//
//  LoginViewModelTests.swift
//  IOSAppTimetonicTests
//
//  Created by Jaime A. Pérez R. on 20/01/24.
//

import XCTest


/// Test suite for LoginViewModel
class LoginViewModelTests: XCTestCase {
    var viewModel: LoginViewModel!

    override func setUp() {
        super.setUp()
        let mockEmailValidator = MockEmailValidator()
        mockEmailValidator.validEmails = ["test@example.com", "user@domain.com"]
        
        let mockPasswordValidator = MockPasswordValidator()
        mockPasswordValidator.validPasswords = ["android56#Developer4", "Android.developer45"]
        
        viewModel = LoginViewModel(emailValidator: mockEmailValidator, passwordValidator: mockPasswordValidator)
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    // Separate test cases for email and password validation
    func testValidEmail() {
        viewModel.user.email = "test@example.com"
        XCTAssertTrue(viewModel.isValidEmail, "Email validation failed for test@example.com")
    }

    func testInvalidEmail() {
        viewModel.user.email = "invalidEmail"
        XCTAssertFalse(viewModel.isValidEmail, "Invalid email should return false")
    }

    func testValidPassword() {
        viewModel.user.password = "android56#Developer4"
        XCTAssertTrue(viewModel.isValidPassword, "Password validation failed for 'password'")
    }

    func testInvalidPassword() {
        viewModel.user.password = "pass"
        XCTAssertFalse(viewModel.isValidPassword, "Invalid password should return false")
    }

    // Additional test cases for edge cases
    func testEmptyEmail() {
        viewModel.user.email = ""
        XCTAssertFalse(viewModel.isValidEmail, "Empty email should return false")
    }

    func testEmptyPassword() {
        viewModel.user.password = ""
        XCTAssertFalse(viewModel.isValidPassword, "Empty password should return false")
    }
}

// Mock implementation of EmailValidating for testing
class MockEmailValidator: EmailValidating {
    var validEmails: Set<String> = []

    func isValidEmail(_ email: String) -> Bool {
        return validEmails.contains(email)
    }
}

// Mock implementation of PasswordValidating for testing
class MockPasswordValidator: PasswordValidating {
    var validPasswords: Set<String> = []

    func isValidPassword(_ password: String) -> Bool {
        return validPasswords.contains(password)
    }
}
