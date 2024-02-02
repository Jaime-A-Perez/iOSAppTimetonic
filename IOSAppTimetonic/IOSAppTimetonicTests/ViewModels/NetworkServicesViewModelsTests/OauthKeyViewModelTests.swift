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
    var networkService : MockNetworkService!
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        networkService = MockNetworkService()
        viewModel = OauthKeyViewModel(networkService: networkService)
    }
    
    override func tearDown() {
        viewModel = nil
        networkService = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testCreateOauthKeySuccess() {
        let mockJson = """
        {
             "status": "ok",
             "oauthkey": "8QyG-XYJ5-sbmW-sDE1-Zpku-K1gP-Hz4t",
             "id": "900133",
             "o_u": "demo",
             "createdVNB": "live-6.49q/6.49",
             "req": "createOauthkey"
        }
        """
        
        networkService.mockOauthKeyJSON = mockJson
        
        let expectation = XCTestExpectation(description: "Create oauthKey successs")
        
        viewModel.$state
            .dropFirst()
            .sink { state in
                if case .success(let oauthKey, let o_u) = state {
                    XCTAssertEqual(oauthKey, "8QyG-XYJ5-sbmW-sDE1-Zpku-K1gP-Hz4t")
                    XCTAssertEqual(o_u, "demo")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.createOauthKey(login: "example@exam.com", pwd: "pxd134", appkey: "hZj4-rWlV-5Xv7-Airx-KXaC-D8Yp-CF7U")
        
        wait(for: [expectation], timeout: 1)
    }
}
