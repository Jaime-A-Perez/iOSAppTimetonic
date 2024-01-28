//
//  AppKeyViewModelTests.swift
//  IOSAppTimetonicTests
//
//  Created by Jaime A. Pérez R. on 28/01/24.
//

@testable import IOSAppTimetonic
import XCTest
import Combine

class AppKeyViewModelTests: XCTestCase {
    var viewModel: AppKeyViewModel!
    var networkService: NetworkService!
    var urlSession: URLSession!
    var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()

        // Set of URLSession with MockURLProtocol
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: config)
        networkService = NetworkService(session: urlSession)

        viewModel = AppKeyViewModel(networkService: networkService)
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

    func testFetchAppKeySuccess() {
        // Setting response and fake data
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "https://example.com/createAppKey")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let mockJSON = """
        {
            "status": "ok",
            "appkey": "hZj4-rWlV-5Xv7-Airx-KXaC-D8Yp-CF7U",
            "id": "946927",
            "createdVNB": "live-6.49q/6.49",
            "req": "createAppkey"
        }
        """
        
        MockURLProtocol.mockData = mockJSON.data(using: .utf8)!

        let expectation = XCTestExpectation(description: "Fetch app key success")

        // Observe changes in the 'appKey' property
        viewModel.fetchAppKey()
        viewModel.$appKey
            .dropFirst()
            .sink { appKey in
                XCTAssertEqual(appKey, "hZj4-rWlV-5Xv7-Airx-KXaC-D8Yp-CF7U")
                expectation.fulfill()
            }
            .store(in: &cancellables)


        wait(for: [expectation], timeout: 2)
    }

}
