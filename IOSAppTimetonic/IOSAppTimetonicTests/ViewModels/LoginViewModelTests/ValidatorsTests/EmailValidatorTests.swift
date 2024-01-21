//
//  EmailValidatorTests.swift
//  IOSAppTimetonicTests
//
//  Created by Jaime A. Pérez R. on 20/01/24.
//

import XCTest

/// Tests for EmailValidator functionality.
final class EmailValidatorTests: XCTestCase {
    
    var emailValidator: EmailValidator!
    
    // Setup method to initialize the EmailValidator before each test
    override func setUp() {
        super.setUp()
        emailValidator = EmailValidator()
    }
    
    // Teardown method to deallocate the EmailValidator after each test
    override func tearDown() {
        emailValidator = nil
        super.tearDown()
    }
    
    // Test case for a valid email address
    func testValidEmail() {
        XCTAssertTrue(emailValidator.isValidEmail("example@example.com"), "Valid email should return true")
    }
    
    // Test case for various invalid email formats
    func testInvalidEmailFormats() {
        let invalidEmails = ["example@", "example@domain", "example.com", "@domain.com", " ", "example@.com", "exa mple@example.com"]
        for email in invalidEmails {
            XCTAssertFalse(emailValidator.isValidEmail(email), "Email '\(email)' should be considered invalid")
        }
    }

}
