//
//  RestaurantDomainTests.swift
//  RestaurantDomainTests
//
//  Created by Kaue de Assis Jacyntho on 20/04/23.
//

import XCTest
@testable import RestaurantDomain

final class RemoteRestaurantLoaderTests: XCTestCase {
    
    func test_initializer_remoteRestaurantLoader_and_validate_urlRequest() throws {
        let anyURL = try XCTUnwrap(URL(string: "https://comitando.com.br"))
        let client = NetworkClientSpy()
        let sut = RemoteRestaurantLoader(url: anyURL, networkClient: client)
        
        sut.load() { _ in }
        
        XCTAssertEqual(client.urlRequests, [anyURL])
    }
    
    func test_load_twice() throws {
        let anyURL = try XCTUnwrap(URL(string: "https://comitando.com.br"))
        let client = NetworkClientSpy()
        let sut = RemoteRestaurantLoader(url: anyURL, networkClient: client)
        
        sut.load() { _ in }
        sut.load() { _ in }
        
        XCTAssertEqual(client.urlRequests, [anyURL, anyURL])
    }
    
    func test_load_and_returned_error_for_connectivity() throws {
        let anyURL = try XCTUnwrap(URL(string: "https://comitando.com.br"))
        let client = NetworkClientSpy()
        let sut = RemoteRestaurantLoader(url: anyURL, networkClient: client)
        client.stateHandler = .error(NSError(domain: "any error", code: -1))

        let exp = expectation(description: "Waiting for return from clousure")
        var returnedResult: RemoteRestaurantLoader.Error?
        
        sut.load() { result in
            returnedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(returnedResult, .connectivity)
    }
    
    func test_load_and_returned_error_for_invaliddata() throws {
        let anyURL = try XCTUnwrap(URL(string: "https://comitando.com.br"))
        let client = NetworkClientSpy()
        let sut = RemoteRestaurantLoader(url: anyURL, networkClient: client)
        client.stateHandler = .success
        
        let exp = expectation(description: "Waiting for return from clousure")
        var returnedResult: RemoteRestaurantLoader.Error?
        
        sut.load() { result in
            returnedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(returnedResult, .invalidData)
    }
}

final class NetworkClientSpy: NetworkClient {
    
    private(set) var urlRequests: [URL] = []
    var stateHandler: NetworkState?
    
    func request(from url: URL, completion: @escaping (NetworkState) -> Void) {
        urlRequests.append(url)
        completion( stateHandler ?? .error(anyError()))
    }
    
    private func anyError() -> Error {
        return NSError(domain: "any error", code: -1)
    }
}
