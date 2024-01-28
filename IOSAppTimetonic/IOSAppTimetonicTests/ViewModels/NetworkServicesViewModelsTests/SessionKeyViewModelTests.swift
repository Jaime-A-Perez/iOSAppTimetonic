//
//  SessionKeyViewModelTests.swift
//  IOSAppTimetonicTests
//
//  Created by Jaime A. Pérez R. on 28/01/24.
//

@testable import IOSAppTimetonic
import XCTest
import Combine

class SessionKeyViewModelTests: XCTestCase {
    var viewModel: SessionKeyViewModel!
    var networkService: NetworkService!
    var urlSession: URLSession!
    var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()

        // Set URLSession with MockURLProtocol
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: config)
        networkService = NetworkService(session: urlSession)

        viewModel = SessionKeyViewModel(networkService: networkService)
    }

    override func tearDown() {
        viewModel = nil
        networkService = nil
        urlSession = nil
        MockURLProtocol.mockData = nil
        MockURLProtocol.mockResponse = nil
        MockURLProtocol.mockError = nil
        super.tearDown()
    }

    func testCreateSessionKeySuccess() {
        // Setting response and fake data
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "https://example.com/createAppKey")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
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
        
        MockURLProtocol.mockData = mockJSON.data(using: .utf8)!

        let expectation = XCTestExpectation(description: "Create OAuth Key Success")
        
        viewModel.createSessionKey(o_u: "demo", oauthkey: "8QyG-XYJ5-sbmW-sDE1-Zpku-K1gP-Hz4t", restrictions: "")
        viewModel.$sesskey
            .dropFirst()
            .sink { sesskey in
                XCTAssertEqual(sesskey, "AwYJ-8Qvj-TMVk-8snb-H93K-iAPQ-SELY")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2)
    }


}
