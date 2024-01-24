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
        let mockJSON = "{\"status\": \"ok\", \"appkey\": \"EMnH-i48x-94qN-9X6Q-GcHL-jQce-miJh\", \"id\": \"945364\", \"createdVNB\": \"live-6.49q/6.49\", \"req\": \"createAppkey\"}"
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

    func testFetchDataFailure() {
        // Configure mock error for this specific test
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

}


