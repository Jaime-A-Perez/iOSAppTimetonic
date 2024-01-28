//
//  OauthKeyViewModelTests.swift
//  IOSAppTimetonicTests
//
//  Created by Jaime A. Pérez R. on 28/01/24.
//

@testable import IOSAppTimetonic
import XCTest
import Combine

class OauthKeyViewModelTests: XCTestCase {
    var viewModel: OauthKeyViewModel!
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

        viewModel = OauthKeyViewModel(networkService: networkService)
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

    func testCreateOauthKeySuccess() {
        // Setting response and fake data
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "https://example.com/createAppKey")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
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
        
        MockURLProtocol.mockData = mockJSON.data(using: .utf8)!

        let expectation = XCTestExpectation(description: "Create OAuth Key Success")
        
        viewModel.createOauthKey(login: "user@example.com", pwd: "password", appkey: "appkey123")
        viewModel.$oauthKey
            .dropFirst()
            .sink { oauthKey in
                XCTAssertEqual(oauthKey, "8QyG-XYJ5-sbmW-sDE1-Zpku-K1gP-Hz4t")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2)
    }


}
