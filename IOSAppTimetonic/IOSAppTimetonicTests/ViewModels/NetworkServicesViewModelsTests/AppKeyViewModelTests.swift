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
    var networkService: MockNetworkService! 
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        networkService = MockNetworkService()
        viewModel = AppKeyViewModel(networkService: networkService)
    }
    
    override func tearDown() {
        viewModel = nil
        networkService = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testFetchAppKeySuccess() {
        let mockJSON = """
        {
            "status": "ok",
            "appkey": "hZj4-rWlV-5Xv7-Airx-KXaC-D8Yp-CF7U",
            "id": "946927",
            "createdVNB": "live-6.49q/6.49",
            "req": "createAppkey"
        }
        """
        networkService.mockAppKeyJSON = mockJSON
        
        let expectation = XCTestExpectation(description: "Fetch app key success")
        
        viewModel.$state
            .dropFirst()
            .sink { state in
                if case .success(let appKey, _) = state {
                    XCTAssertEqual(appKey, "hZj4-rWlV-5Xv7-Airx-KXaC-D8Yp-CF7U", "El appKey recibido debe coincidir con el valor esperado")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.fetchAppKey()
        
        wait(for: [expectation], timeout: 1)
    }
}


