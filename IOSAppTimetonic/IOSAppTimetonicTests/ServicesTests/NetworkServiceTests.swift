//
//  NetworkServiceTests.swift
//  IOSAppTimetonicTests
//
//  Created by Jaime A. Pérez R. on 23/01/24.
//

import XCTest
@testable import IOSAppTimetonic

class NetworkServiceTests: XCTestCase {
    var networkService: NetworkService!

    override func setUp() {
        super.setUp()
        // General setup for URLSession with MockURLProtocol
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        networkService = NetworkService(session: URLSession(configuration: config))
    }

    override func tearDown() {
        networkService = nil
        MockURLProtocol.mockData = nil
        MockURLProtocol.mockResponse = nil
        MockURLProtocol.mockError = nil
        super.tearDown()
    }
    
        
    func testCreateAppKeySuccess() {
        // Configure mock data and response for this specific test
        let mockResponse = HTTPURLResponse(url: URL(string: "https://example.com/createAppKey")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let mockJSON = """
        {
            "status": "ok",
            "appkey": "hZj4-rWlV-5Xv7-Airx-KXaC-D8Yp-CF7U",
            "id": "946927",
            "createdVNB": "live-6.49q/6.49",
            "req": "createAppkey"
        }
        """
        
        MockURLProtocol.mockResponse = mockResponse
        MockURLProtocol.mockData = mockJSON.data(using: .utf8)

        let expectation = self.expectation(description: "CreateAppKeySuccess")

        networkService.createAppKey { result in
            switch result {
            case .success(_):
                // Validate response content here
                expectation.fulfill()
            case .failure(_):
                XCTFail("Expected success in the response")
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testCreateAppKeyFailure() {
        // Configure mock error for appkey creation
        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        MockURLProtocol.mockError = error

        let expectation = self.expectation(description: "FetchDataFailure")

        networkService.createAppKey { result in
            switch result {
            case .success(_):
                XCTFail("Expected an error in the response")
            case .failure(let err as NSError):
                print(err)
                XCTAssertEqual(err.code, 0)
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateOauthKeySuccess() {
        // Mock data for successful OAuth key creation
        let mockResponse = HTTPURLResponse(url: URL(string: "https://example.com/createOauthKey")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let mockJSON = """
        {
            "status": "ok",
            "oauthkey": "8QyG-XYJ5-sbmW-sDE1-Zpku-K1gP-Hz4t",
            "id": "900133",
            "o_u": "demo",
            "createdVNB": "live-6.49q/6.49",
            "req": "createOauthkey"
        }
        """
        MockURLProtocol.mockResponse = mockResponse
        MockURLProtocol.mockData = mockJSON.data(using: .utf8)

        let expectation = self.expectation(description: "CreateOauthKeySuccess")

        networkService.createOauthKey(login: "user@example.com", pwd: "password", appkey: "appkey123") { result in
            switch result {
            case .success(let oauthKey):
                // Validate response content here
                XCTAssertEqual(oauthKey.oauthkey, "8QyG-XYJ5-sbmW-sDE1-Zpku-K1gP-Hz4t", "OAuth key does not match expected value")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success in the response, got error: \(error)")
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateOauthKeyFailure() {
        // Configure mock error for appkey creation
        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        MockURLProtocol.mockError = error

        let expectation = self.expectation(description: "FetchDataFailure")

        networkService.createOauthKey(login: "user@example.com", pwd: "password", appkey: "appkey123") { result in
            switch result {
            case .success(_):
                XCTFail("Expected an error in the response")
            case .failure(let err as NSError):
                print(err)
                XCTAssertEqual(err.code, 0)
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

}

