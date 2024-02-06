//
//  MockURLProtocol.swift
//  IOSAppTimetonicTests
//
//  Created by Jaime A. Pérez R. on 23/01/24.
//

import Foundation

// To simulate network responses
class MockURLProtocol: URLProtocol {
    // Data to be returned as part of the simulated response
    static var mockData: Data?
    
    // Error to be returned as part of the simulated response
    static var mockError: NSError?

    // HTTP Response to be returned as part of the simulated response
    static var mockResponse: HTTPURLResponse?

    // This method determines whether this protocol can handle the given request
    override class func canInit(with request: URLRequest) -> Bool {
        // Here, it's set to always return true, indicating that this protocol can handle all requests
        return true
    }
    
    // This method returns a canonical version of the request
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        // It simply returns the original request without modification
        return request
    }
    
    // This method starts loading the request
    override func startLoading() {
        if let error = MockURLProtocol.mockError {
            // Simulate an error scenario
            self.client?.urlProtocol(self, didFailWithError: error)
        } else {
            if let response = MockURLProtocol.mockResponse {
                // Send a custom HTTP response if available
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }

            if let data = MockURLProtocol.mockData {
                // Send the mock data
                self.client?.urlProtocol(self, didLoad: data)
            }
        }

        // Notify the client that loading has finished
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        // No actual network request to cancel, but this is where you would clean up if there was
    }
}
