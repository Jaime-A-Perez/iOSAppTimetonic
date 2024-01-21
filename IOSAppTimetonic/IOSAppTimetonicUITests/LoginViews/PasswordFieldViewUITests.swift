//
//  PasswordFieldViewUITests.swift
//  IOSAppTimetonicUITests
//
//  Created by Jaime A. Pérez R. on 21/01/24.
//

import XCTest

final class PasswordFieldViewUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }
    
    func testPasswordValidationIcon(_ password: String, expectedIcon: String) {
        let passwordSecureField = app.secureTextFields["passwordSecureField"]
        XCTAssertTrue(passwordSecureField.exists, "Password secure text field does not exist")
        
        passwordSecureField.tap()
        passwordSecureField.typeText(password)
        
        let passwordValidationIcon = app.images["passwordValidationIcon"]
        XCTAssertTrue(passwordValidationIcon.exists, "Password validation icon does not exist")
        
        // Verify that the validation icon has the correct label
        XCTAssertEqual(passwordValidationIcon.label, expectedIcon, "Validation icon should be '\(expectedIcon)' for the provided password")
    }
    
    func testValidPassword() {
        testPasswordValidationIcon("Password123!", expectedIcon: "Selected")
    }
    
    func testInvalidPassword() {
        testPasswordValidationIcon("abc", expectedIcon: "x.circle")
    }
}

