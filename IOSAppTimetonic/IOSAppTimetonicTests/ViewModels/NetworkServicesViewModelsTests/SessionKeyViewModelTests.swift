//
//  SessionKeyViewModelTests.swift
//  IOSAppTimetonicTests
//
//  Created by Jaime A. Pérez R. on 28/01/24.
//

@testable import IOSAppTimetonic
import XCTest
import Combine

@testable import IOSAppTimetonic
import XCTest
import Combine

class SessKeyViewModelTests: XCTestCase {
    var viewModel: SessionKeyViewModel!
    var networkService: MockNetworkService! // Usa un mock directo del servicio de red
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        networkService = MockNetworkService()
        viewModel = SessionKeyViewModel(networkService: networkService)
    }
    
    override func tearDown() {
        viewModel = nil
        networkService = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testFetchSessKeySuccess() {
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
        networkService.mockSessKeyJSON = mockJSON
        
        let expectation = XCTestExpectation(description: "Fetch sesskey success")
        
        viewModel.$state
            .dropFirst() // Ignora el estado inicial
            .sink { state in
                if case .success(let sessKey, _) = state {
                    XCTAssertEqual(sessKey, "AwYJ-8Qvj-TMVk-8snb-H93K-iAPQ-SELY", "El SessKey recibido debe coincidir con el valor esperado")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.createSessionKey(o_u: "demo", oauthkey: "hZj4-rWlV-5Xv7-Airx-KXaC-D8Yp-CF7U", restrictions: "")
        
        wait(for: [expectation], timeout: 1)
    }
}

                                   
