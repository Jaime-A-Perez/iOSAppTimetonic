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

    
    func testGetAllBooksSuccess() {
        // Setup the mock response with the provided JSON structure
        let mockResponseJSON = """
        {
            "status": "ok",
            "sstamp": 17074267355383,
            "allBooks": {
                "nbBooks": 5,
                "nbContacts": 0,
                "contacts": [],
                "books": [
                    {
                        "invited": true,
                        "accepted": true,
                        "archived": false,
                        "showFpOnOpen": true,
                        "sstamp": 17014198397562,
                        "del": false,
                        "hideMessage": "2",
                        "hideBookMembers": "2",
                        "description": "Another project ! Super cool ! But hey, wait a second,  what is up with the 20 other ones we must undertake ?\\n\\nDifficult to jungle with different projects as a team. With this template, you can follow the progress of all of them in the same place, task by task, or consult the clients' information at any time !\\n\\nTake example on this students' association that produces videos for their school events. Let's have a look >>",
                        "defaultTemplate": "0",
                        "isDownloadable": false,
                        "canDisableSync": false,
                        "b_c": "projectstracker",
                        "b_o": "androiddeveloper",
                        "cluster": "1",
                        "tags": null,
                        "langs": null,
                        "contact_u_c": null,
                        "nbNotRead": 0,
                        "nbMembers": 1,
                        "members": [
                            {
                                "u_c": "androiddeveloper",
                                "invite": "accepted",
                                "right": 4,
                                "access": 1,
                                "hideMessage": "2",
                                "hideBookMembers": "2",
                                "apiRight": "0"
                            }
                        ],
                        "fpForm": {
                            "fpid": 76294,
                            "name": "projectstracker.androiddeveloper",
                            "lastModified": 1705818193
                        },
                        "lastMsg": {
                            "smid": 110681336,
                            "uuid": "addDb-1701372174-964ea789779f3289d3c1d5e9e1962354",
                            "sstamp": 17013721742940,
                            "lastCommentId": 110681336,
                            "msgBody": "",
                            "msgType": "m",
                            "msgMethod": "_welcome",
                            "msgColor": "",
                            "nbComments": 0,
                            "pid": 0,
                            "nbMedias": 0,
                            "nbEmailCids": 0,
                            "nbDocs": 0,
                            "b_c": "projectstracker",
                            "b_o": "androiddeveloper",
                            "u_c": "timetonic",
                            "linkedRowId": null,
                            "linkedTabId": null,
                            "linkMessage": "",
                            "linkedFieldId": null,
                            "msg": "Book creation",
                            "del": false,
                            "created": 1701372174,
                            "lastModified": 1701372174
                        },
                        "nbMsgs": 1,
                        "userPrefs": {
                            "maxMsgsOffline": 100,
                            "syncWithHubic": false,
                            "uCoverLetOwnerDecide": true,
                            "uCoverColor": "orange",
                            "uCoverUseLastImg": false,
                            "uCoverImg": "\\/dev\\/dbi\\/in\\/tb\\/FU-1701419839-65699b3f78400\\/modele-suivi-projet.jpg",
                            "uCoverType": "image",
                            "inGlobalSearch": true,
                            "inGlobalTasks": true,
                            "notifyEmailCopy": false,
                            "notifySmsCopy": false,
                            "notifyMobile": true,
                            "notifyWhenMsgInArchivedBook": true
                        },
                        "ownerPrefs": {
                            "fpAutoExport": true,
                            "oCoverColor": "jaune-indien",
                            "oCoverUseLastImg": false,
                            "oCoverImg": "\\/dev\\/dbi\\/in\\/tb\\/FU-1701419839-65699b3f78400\\/modele-suivi-projet.jpg",
                            "oCoverType": "image",
                            "authorizeMemberBroadcast": true,
                            "acceptExternalMsg": true,
                            "title": "Projects Tracker",
                            "notifyMobileConfidential": false
                        },
                        "sbid": 78492,
                        "lastMsgRead": 110681338,
                        "lastMedia": 7757338,
                        "favorite": true,
                        "order": 0
                    }
                    // Include other books as needed for testing
                ]
            },
            "createdVNB": "live-6.49q/6.49",
            "req": "getAllBooks"
        }
        """.data(using: .utf8)!
        
        MockURLProtocol.mockResponse = HTTPURLResponse(url: URL(string: "\(Constants.API.baseUrl)\(Constants.API.getAllBooks)")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        MockURLProtocol.mockData = mockResponseJSON
        
        let expectation = self.expectation(description: "getAllBooks success response")
        
        networkService.getAllBooks()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Failed with error: \(error)")
                }
            }, receiveValue: { apiResponse in
                XCTAssertEqual(apiResponse.booksResponse?.books.count, 5, "The number of books should be 5")
                XCTAssertEqual(apiResponse.booksResponse?.books.first?.invited, true,  "The invited of the first book should match the provided bool")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 2.5, handler: nil)
    }
}
