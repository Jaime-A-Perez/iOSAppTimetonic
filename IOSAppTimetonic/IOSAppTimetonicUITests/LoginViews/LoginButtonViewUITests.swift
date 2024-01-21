//
//  LoginButtonViewUITests.swift
//  IOSAppTimetonicUITests
//
//  Created by Jaime A. Pérez R. on 21/01/24.
//

import XCTest

final class LoginButtonViewUITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }

    // Function to configure the login state with provided email and password
    private func configureLoginState(email: String, password: String) {
        let emailTextField = app.textFields["emailTextField"]
        let passwordSecureField = app.secureTextFields["passwordSecureField"]

        emailTextField.tap()
        emailTextField.typeText(email)

        passwordSecureField.tap()
        passwordSecureField.typeText(password)
    }

    // Test to verify that the login button is enabled with valid credentials
    func testLoginButtonEnabledWithValidCredentials() {
        configureLoginState(email: "test@example.com", password: "Password123!")

        let loginButton = app.buttons["loginButton"]
        XCTAssertTrue(loginButton.isEnabled, "Login button should be enabled with valid credentials")
    }
    
    // Test to verify that the login button is disabled with invalid credentials
    func testLoginButtonDisabledWithInvalidCredentials() {
        configureLoginState(email: "test.com", password: "123!")

        let loginButton = app.buttons["loginButton"]
        XCTAssertFalse(loginButton.isEnabled, "Login button should be disabled with invalid credentials")
    }

}
