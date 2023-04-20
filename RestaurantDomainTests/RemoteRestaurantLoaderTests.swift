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
        sut.load()
        
        XCTAssertEqual(client.urlRequest, anyURL)
    }
}

final class NetworkClientSpy: NetworkClient {
    private(set) var urlRequest: URL?
    
    func request(from url: URL) {
        urlRequest = url
    }
}
