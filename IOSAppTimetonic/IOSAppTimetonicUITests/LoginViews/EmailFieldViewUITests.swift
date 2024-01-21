//
//  EmailFieldViewUITests.swift
//  IOSAppTimetonicUITests
//
//  Created by Jaime A. Pérez R. on 21/01/24.
//

import XCTest

final class EmailFieldViewUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }
    
    func testEmailValidationIcon(_ email: String, expectedIcon: String) {
        let emailTextField = app.textFields["emailTextField"]
        XCTAssertTrue(emailTextField.exists, "Email text field does not exist")
        
        emailTextField.tap()
        emailTextField.typeText(email)
        
        let emailValidationIcon = app.images["emailValidationIcon"]
        XCTAssertTrue(emailValidationIcon.exists, "Email validation icon does not exist")
        
        // Verify that the validation icon has the correct label
        XCTAssertEqual(emailValidationIcon.label, expectedIcon, "Validation icon should be '\(expectedIcon)' for the provided email: \(email)")
    }
    
    func testInvalidEmailFormat() {
        testEmailValidationIcon("invalid_email", expectedIcon: "x.circle")
    }
    
    func testValidEmail() {
        testEmailValidationIcon("valid@example.com", expectedIcon: "Selected")
    }
}
