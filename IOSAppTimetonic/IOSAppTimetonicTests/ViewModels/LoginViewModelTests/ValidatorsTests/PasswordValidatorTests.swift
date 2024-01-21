//
//  PasswordValidatorTests.swift
//  IOSAppTimetonicTests
//
//  Created by Jaime A. Pérez R. on 20/01/24.
//

import XCTest

/// Tests for PasswordValidator functionality.
final class PasswordValidatorTests: XCTestCase {
    var passwordValidator: PasswordValidator!

    // Setup method to initialize PasswordValidator before each test
    override func setUp() {
        super.setUp()
        passwordValidator = PasswordValidator()
    }

    // Teardown method to deallocate PasswordValidator after each test
    override func tearDown() {
        passwordValidator = nil
        super.tearDown()
    }

    // Test case for a valid password
    func testValidPassword() {
        XCTAssertTrue(passwordValidator.isValidPassword("Android.developer45"), "A valid password should return true")
    }

    // Test case for an invalid password due to short length
    func testInvalidPassword_ShortLength() {
        XCTAssertFalse(passwordValidator.isValidPassword("1234"), "A short password should return false")
    }

   
}
