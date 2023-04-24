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
        let (sut, client, anyURL) = try makeSUT()

        sut.load() { _ in }
        
        XCTAssertEqual(client.urlRequests, [anyURL])
    }
    
    func test_load_twice() throws {
        let (sut, client, anyURL) = try makeSUT()

        sut.load() { _ in }
        sut.load() { _ in }
        
        XCTAssertEqual(client.urlRequests, [anyURL, anyURL])
    }
    
    func test_load_and_returned_error_for_connectivity() throws {
        let (sut, client, _) = try makeSUT()

        let exp = expectation(description: "Waiting for return from clousure")
        var returnedResult: RemoteRestaurantLoader.Error?
        
        sut.load() { result in
            returnedResult = result
            exp.fulfill()
        }
        
        client.completionWithError()

        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(returnedResult, .connectivity)
    }
    
    func test_load_and_returned_error_for_invaliddata() throws {
        let (sut, client, _) = try makeSUT()
        
        let exp = expectation(description: "Waiting for return from clousure")
        var returnedResult: RemoteRestaurantLoader.Error?
        
        sut.load() { result in
            returnedResult = result
            exp.fulfill()
        }
        
        client.completionWithSuccess()
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(returnedResult, .invalidData)
    }
    
    private func makeSUT() throws -> (sut: RemoteRestaurantLoader, client: NetworkClientSpy, anyURL: URL) {
        let anyURL = try XCTUnwrap(URL(string: "https://comitando.com.br"))
        let client = NetworkClientSpy()
        let sut = RemoteRestaurantLoader(url: anyURL, networkClient: client)
        
        return (sut, client, anyURL)
    }
}

final class NetworkClientSpy: NetworkClient {
    
    private(set) var urlRequests: [URL] = []
    private var completionHandler: ((NetworkState) -> Void)?
    
    func request(from url: URL, completion: @escaping (NetworkState) -> Void) {
        urlRequests.append(url)
        completionHandler = completion
    }
    
    func completionWithError() {
        completionHandler?(.error(anyError()))
    }
    
    func completionWithSuccess() {
        completionHandler?(.success)
    }
    
    private func anyError() -> Error {
        return NSError(domain: "any error", code: -1)
    }
}
