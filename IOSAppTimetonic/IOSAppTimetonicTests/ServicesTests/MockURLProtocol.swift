//
//  MockURLProtocol.swift
//  IOSAppTimetonicTests
//
//  Created by Jaime A. Pérez R. on 23/01/24.
//

import Foundation

// To simulate network responses
class MockURLProtocol: URLProtocol {
    // It is used to store the data that will be returned as part of the simulated response
    static var mockData: Data?
    
    // Overrides the class method 'canInit(with:)'. This method determines whether this protocol can handle the given request
    override class func canInit(with request: URLRequest) -> Bool {
        // Here, it's set to always return true, indicating that this protocol can handle all requests
        return true
    }
    
    // Overrides the class method 'canonicalRequest(for:)'. This method returns a canonical version of the request
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        // In this implementation, it simply returns the original request without modification
        return request
    }
    
    // Overrides the instance method 'startLoading'. This method starts loading the request
    override func startLoading() {
        // Here, it checks if mock data is available, and if so, sends it to the client as a response
        if let data = MockURLProtocol.mockData {
            self.client?.urlProtocol(self, didLoad: data)
        }
        // It then notifies the client that loading has finished
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    //  This method stops loading the request
    override func stopLoading() {
        // It's empty in this case, as there's no actual network request to cancel
    }
}
