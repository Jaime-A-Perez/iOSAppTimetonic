//
//  NetworkServiceTests.swift
//  IOSAppTimetonicTests
//
//  Created by Jaime A. Pérez R. on 23/01/24.
//

import XCTest
import Combine
@testable import IOSAppTimetonic

class NetworkServiceTests: XCTestCase {
    var networkService: NetworkService!
    var cancellables = Set<AnyCancellable>()

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
        
        let publisher = networkService.createAppKey()
        let cancelable = publisher.sink { _ in } receiveValue: { appKeyResponse in
            XCTAssertEqual(appKeyResponse.appkey, "hZj4-rWlV-5Xv7-Airx-KXaC-D8Yp-CF7U")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
        cancelable.cancel()
    }

    func testCreateAppKeyFailure() {
        // Configure mock error for appkey creation
        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        MockURLProtocol.mockError = error
        
        let expectation = self.expectation(description: "FetchDataFailure")
        
        let publisher = networkService.createAppKey()
        let cancelable = publisher
            .sink(receiveCompletion: { completion in
                if case.failure(let error as NSError) = completion {
                    XCTAssertEqual(error.code, 3)
                    expectation.fulfill()
                }
            },   receiveValue: {_ in })
        
        wait(for: [expectation], timeout: 1)
        cancelable.cancel()
    }
    
    func testCreateOauthKeySuccess() {
        // Configure mock data and response for this specific test
        let mockResponse = HTTPURLResponse(url: URL(string: "\(Constants.API.baseUrl)\(Constants.API.createOauthkey)")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
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
        
        let expectation = XCTestExpectation(description: "CreateOauthKeySuccess")
        
        let publisher = networkService.createOauthKey(login: "user@example.com", pwd: "Password12!", appkey: "hZj4-rWlV-5Xv7-Airx-KXaC-D8Yp-CF7U")
        let cancelable = publisher.sink { _ in } receiveValue: { oauthKeyResponse in
                XCTAssertEqual(oauthKeyResponse.oauthkey, "8QyG-XYJ5-sbmW-sDE1-Zpku-K1gP-Hz4t")
                expectation.fulfill()
            }
        
        wait(for: [expectation], timeout: 1)
        cancelable.cancel()
    }

    func testCreateOauthKeyFailure() {
        // Configure mock error for appkey creation
        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        MockURLProtocol.mockError = error
        
        let expectation = XCTestExpectation(description: "CreateOauthKeyFailure")
        
        let publisher = networkService.createOauthKey(login: "example@ex.com", pwd: "Paswe!", appkey: "123")
        let cancelable = publisher
            .sink(receiveCompletion: {completion in
                if case.failure(let error as NSError) = completion {
                    XCTAssertEqual(error.code, 3)
                    expectation.fulfill()
                }
            }, receiveValue: { _ in })
        
        wait(for: [expectation], timeout: 1)
        cancelable.cancel()
    }
    
    func testCreateSesskeySuccess() {
        // Configure mock data and response for this specific test
        let mockResponse = HTTPURLResponse(url: URL(string: "\(Constants.API.baseUrl)\(Constants.API.createSesskey)")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let mockJSON = """
        {
            "status": "ok",
            "sesskey": "AwYJ-8Qvj-TMVk-8snb-H93K-iAPQ-SELY",
            "id": "1020463",
            "restrictions": {
                "carnet_code": null,
                "carnet_owner": null,
                "readonly": false,
                "hideTables": false,
                "hideMessages": false,
                "hideEvents": false,
                "internal": false
            },
            "appName": "api",
            "createdVNB": "live-6.49q/6.49",
            "req": "createSesskey"
        }
        """
        MockURLProtocol.mockResponse = mockResponse
        MockURLProtocol.mockData = mockJSON.data(using: .utf8)

        let expectation = self.expectation(description: "CreateSesskeySuccess")

        // Execute createSesskey function
        let publisher = networkService.createSesskey(o_u: "demo", oauthkey: "8QyG-XYJ5-sbmW-sDE1-Zpku-K1gP-Hz4t", restrictions: "")
        let cancellable = publisher.sink(receiveCompletion: { _ in }, receiveValue: { sessKeyResponse in
            XCTAssertEqual(sessKeyResponse.sesskey, "AwYJ-8Qvj-TMVk-8snb-H93K-iAPQ-SELY")
            expectation.fulfill()
        })

        waitForExpectations(timeout: 1)
        cancellable.cancel()
    }

    func testCreateSesskeyFailure() {
        // Configure mock error for appkey creation
        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        MockURLProtocol.mockError = error

        let expectation = self.expectation(description: "CreateSesskeyFailure")

        // Execute createSesskey function
        let publisher = networkService.createSesskey(o_u: "demo", oauthkey: "8QyG-XYJ5-sbmW-sDE1-Zpku-K1gP-Hz4t", restrictions: "")
        let cancellable = publisher.sink(receiveCompletion: { completion in
            if case .failure(let error as NSError) = completion {
                XCTAssertEqual(error.code, 3)
                expectation.fulfill()
            }
        }, receiveValue: { _ in })
        
        waitForExpectations(timeout: 1)
        cancellable.cancel()
    }


}

