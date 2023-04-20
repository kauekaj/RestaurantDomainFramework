//
//  RestaurantDomainTests.swift
//  RestaurantDomainTests
//
//  Created by Kaue de Assis Jacyntho on 20/04/23.
//

import XCTest
@testable import RestaurantDomain

final class RestaurantDomainTests: XCTestCase {

    func test_initializer_remoteRestaurantLoader_and_validate_urlRequest() throws {
        let anyURL = try XCTUnwrap(URL(string: "https://comitando.com.br"))
        let sut = RemoteRestaurantLoader(url: anyURL)
        
        sut.load()
        
        XCTAssertNotNil(NetworkClient.shared.urlRequest)
    }
}
